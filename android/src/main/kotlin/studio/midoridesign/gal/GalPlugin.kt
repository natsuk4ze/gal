package studio.midoridesign.gal

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import org.apache.commons.imaging.ImageFormat
import org.apache.commons.imaging.Imaging
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.io.InputStream
import java.util.Locale

class GalPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {
    private var channel: MethodChannel? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activity: Activity? = null
    private var requestAccessCallback: Runnable? = null
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gal")
        channel?.setMethodCallHandler(this)
        pluginBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        pluginBinding = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "putVideo", "putImage" -> {
                Thread {
                    try {
                        val path = call.argument<String>("path")
                        if (path == null) {
                            result.error(
                                "PATH_IS_REQUIRED",
                                "The path argument is required",
                                null,
                            )
                            return@Thread
                        }
                        putMedia(
                            path, call.argument("album"),
                            call.method.contains("Image")
                        )
                        Handler(Looper.getMainLooper()).post { result.success(null) }
                    } catch (e: Exception) {
                        handleError(e, result)
                    }
                }.start()
            }

            "putImageBytes" -> {
                Thread {
                    try {
                        val bytes = call.argument<ByteArray>("bytes")
                        if (bytes == null) {
                            result.error(
                                "BYTES_IS_REQUIRED",
                                "The bytes argument is required",
                                null,
                            )
                            return@Thread
                        }
                        putMediaBytes(bytes, call.argument<String?>("album"))
                        Handler(Looper.getMainLooper()).post { result.success(null) }
                    } catch (e: Exception) {
                        handleError(e, result)
                    }
                }.start()
            }

            "open" -> {
                open()
                Handler(Looper.getMainLooper()).post { result.success(null) }
            }

            "hasAccess" -> {
                result.success(hasAccess(call.argument("toAlbum") ?: DEFAULT_TO_ALBUM))
            }

            "requestAccess" -> {
                if (hasAccess(call.argument<Boolean>("toAlbum") ?: DEFAULT_TO_ALBUM)) {
                    result.success(true)
                    return
                }
                requestAccessCallback =
                    Runnable {
                        result.success(
                            hasAccess(
                                call.argument("toAlbum") ?: DEFAULT_TO_ALBUM
                            )
                        )
                    }
                requestAccess()
            }

            else -> result.notImplemented()
        }
    }

    @Throws(IOException::class, SecurityException::class, FileNotFoundException::class)
    private fun putMedia(path: String, album: String?, isImage: Boolean) {
        val file = File(path)
        val name = file.name
        val dotIndex = name.lastIndexOf('.')
        if (dotIndex == -1) throw FileNotFoundException("Extension not found.")
        FileInputStream(file).use { outputStream ->
            writeData(
                outputStream,
                isImage,
                name.substring(0, dotIndex),
                name.substring(dotIndex),
                album
            )
        }
    }

    @Throws(IOException::class, SecurityException::class)
    private fun putMediaBytes(bytes: ByteArray, album: String?) {
        val imageFormat: ImageFormat = Imaging.guessFormat(bytes)
        val extension = "." + imageFormat.defaultExtension.lowercase(Locale.getDefault())
        ByteArrayInputStream(bytes).use { byteArrayInputStream ->
            writeData(byteArrayInputStream, true, "image", extension, album)
        }
    }

    @Throws(IOException::class, SecurityException::class, FileNotFoundException::class)
    private fun writeData(
        inputStream: InputStream,
        isImage: Boolean,
        name: String,
        extension: String,
        album: String?
    ) {
        val resolver: ContentResolver? = pluginBinding?.applicationContext?.contentResolver
        val values: ContentValues = createContentValues(isImage, name, extension, album)
        val uri: Uri? = resolver?.insert(if (isImage) IMAGE_URI else VIDEO_URI, values)
        uri?.let {
            resolver.openOutputStream(it).use { out ->
                val buffer = ByteArray(8192)
                var bytesRead: Int
                while (inputStream.read(buffer).also { value ->
                        bytesRead = value
                    } != -1) {
                    out?.write(buffer, 0, bytesRead)
                }
            }
        }
    }

    private fun createContentValues(
        isImage: Boolean, name: String, extension: String,
        album: String?
    ): ContentValues {
        val values = ContentValues()
        val dirPath =
            if (isImage || album != null) Environment.DIRECTORY_PICTURES else Environment.DIRECTORY_MOVIES
        if (USE_EXTERNAL_STORAGE) {
            val dir = File(
                Environment.getExternalStoragePublicDirectory(dirPath),
                album ?: ""
            )
            if (!dir.exists()) dir.mkdirs()
            var path: String?
            val n = dir.path + File.separator + name
            var i = 0
            while (File(n + (if (i == 0) "" else i) + extension.also { path = it }).exists()) {
                i++
            }
            values.put(MediaStore.MediaColumns.DATA, path)
        } else {
            val path = dirPath + if (album != null) File.separator + album else ""
            values.put(
                if (isImage) MediaStore.Images.Media.RELATIVE_PATH else MediaStore.Video.Media.RELATIVE_PATH,
                path
            )
        }
        values.put(MediaStore.MediaColumns.DISPLAY_NAME, name + extension)
        return values
    }

    private fun open() {
        val intent = Intent()
        intent.action = Intent.ACTION_VIEW
        if (Build.VERSION.SDK_INT <= 23) {
            intent.type = "*/*"
            intent.putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("image/*", "video/*"))
        } else {
            intent.data = IMAGE_URI
        }
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        pluginBinding?.applicationContext?.startActivity(intent)
    }

    private fun hasAccess(toAlbum: Boolean): Boolean {
        if (Build.VERSION.SDK_INT < 23 || Build.VERSION.SDK_INT > 29) return true
        if (Build.VERSION.SDK_INT == 29 && !toAlbum) return true
        val context: Context = pluginBinding?.applicationContext
            ?: throw NullPointerException("The application context can't be null")
        val status: Int = ContextCompat.checkSelfPermission(context, PERMISSION)
        return status == PackageManager.PERMISSION_GRANTED
    }

    private fun requestAccess() {
        activity?.let {
            ActivityCompat.requestPermissions(
                it, arrayOf(PERMISSION),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun sendError(
        errorCode: String, message: String, stackTrace: Array<StackTraceElement>,
        result: MethodChannel.Result
    ) {
        val trace = StringBuilder()
        for (st in stackTrace) {
            trace.append(st.toString())
            trace.append("\n")
        }
        Handler(Looper.getMainLooper())
            .post { result.error(errorCode, message, trace.toString()) }
    }

    private fun handleError(e: Exception, result: MethodChannel.Result) {
        val errorCode: String =
            if (e is SecurityException || e.toString().contains("Permission denied")) {
                "ACCESS_DENIED"
            } else if (e is FileNotFoundException) {
                "NOT_SUPPORTED_FORMAT"
            } else if (e is IOException && e.toString().contains("No space left on device")) {
                "NOT_ENOUGH_SPACE"
            } else {
                "UNEXPECTED"
            }
        sendError(errorCode, e.toString(), e.stackTrace, result)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
        activityPluginBinding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(
        activityPluginBinding: ActivityPluginBinding
    ) {
        activity = activityPluginBinding.activity
        activityPluginBinding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode != PERMISSION_REQUEST_CODE || grantResults.isEmpty()) return false
        requestAccessCallback?.let { Handler(Looper.getMainLooper()).post(it) }
        requestAccessCallback = null
        return true
    }

    companion object {
        private const val PERMISSION = Manifest.permission.WRITE_EXTERNAL_STORAGE
        private val IMAGE_URI: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        private val VIDEO_URI: Uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
        private const val PERMISSION_REQUEST_CODE = 1317298 // Anything unique in the app.
        private val USE_EXTERNAL_STORAGE: Boolean = Build.VERSION.SDK_INT <= 29
        private const val DEFAULT_TO_ALBUM = false
    }
}