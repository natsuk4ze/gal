package studio.midoridesign.gal;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Looper;
import android.os.Build;
import android.net.Uri;
import android.provider.MediaStore;
import android.Manifest;
import android.app.Activity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayInputStream;
import java.util.concurrent.CompletableFuture;

public class GalPlugin
        implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
    private static final String PERMISSION = Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private static final Uri IMAGE_URI = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
    private static final Uri VIDEO_URI = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
    private static final int PERMISSION_REQUEST_CODE = 1317298; // Anything unique in the app.
    private static final boolean hasAccessByDefault = Build.VERSION.SDK_INT < Build.VERSION_CODES.M
            || Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q;

    private MethodChannel channel;
    private FlutterPluginBinding pluginBinding;
    private CompletableFuture<Boolean> accessRequestResult;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gal");
        channel.setMethodCallHandler(this);
        pluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "putVideo":
            case "putImage": {
                CompletableFuture.runAsync(() -> {
                    try {
                        putMedia(pluginBinding.getApplicationContext(), (String) call.argument("path"),
                                call.method.contains("Image"));
                        new Handler(Looper.getMainLooper()).post(() -> result.success(null));
                    } catch (Exception e) {
                        handleError(e, result);
                    }
                });
                break;
            }
            case "putImageBytes": {
                CompletableFuture.runAsync(() -> {
                    try {
                        putImageBytes(pluginBinding.getApplicationContext(), (byte[]) call.argument("bytes"));
                        new Handler(Looper.getMainLooper()).post(() -> result.success(null));
                    } catch (Exception e) {
                        handleError(e, result);
                    }
                });
                break;
            }
            case "open": {
                open();
                new Handler(Looper.getMainLooper())
                        .post(() -> result.success(null));
                break;
            }
            case "hasAccess": {
                result.success(hasAccessByDefault ? true : hasAccess());
                break;
            }
            case "requestAccess": {
                if (hasAccessByDefault) {
                    result.success(true);
                    return;
                }
                requestAccess().thenAccept(result::success);
                break;
            }
            default:
                result.notImplemented();
        }
    }

    private void putMedia(Context context, String path, boolean isImage)
            throws IOException, SecurityException, FileNotFoundException {
        File file = new File(path);
        try (InputStream in = new FileInputStream(file)) {
            writeContent(context, in, isImage);
        }
    }

    private void putImageBytes(Context context, byte[] bytes)
            throws IOException, SecurityException {
        try (InputStream in = new ByteArrayInputStream(bytes)) {
            writeContent(context, in, true);
        }
    }

    private void writeContent(Context context, InputStream in, boolean isImage)
            throws IOException, SecurityException {
        ContentResolver resolver = context.getContentResolver();
        ContentValues values = new ContentValues();
        values.put(MediaStore.MediaColumns.DATE_ADDED, System.currentTimeMillis());
        Uri mediaUri = resolver.insert(isImage ? IMAGE_URI : VIDEO_URI, values);

        try (OutputStream out = resolver.openOutputStream(mediaUri)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    private void open() {
        Context context = pluginBinding.getApplicationContext();
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setType("image/*");
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    private boolean hasAccess() {
        Context context = pluginBinding.getApplicationContext();
        int status = ContextCompat.checkSelfPermission(context, PERMISSION);
        return status == PackageManager.PERMISSION_GRANTED;
    }

    // If permissions have already been granted by the user,
    // returns true immediately without displaying the dialog.
    private CompletableFuture<Boolean> requestAccess() {
        accessRequestResult = new CompletableFuture<>();
        ActivityCompat.requestPermissions(activity, new String[] { PERMISSION }, PERMISSION_REQUEST_CODE);
        return accessRequestResult;
    }

    private void sendError(String errorCode, String message, StackTraceElement[] stackTrace, Result result) {
        StringBuilder trace = new StringBuilder();
        for (StackTraceElement st : stackTrace) {
            trace.append(st.toString());
            trace.append("\n");
        }
        new Handler(Looper.getMainLooper())
                .post(() -> result.error(errorCode, message, trace.toString()));
    }

    private void handleError(Exception e, Result result) {
        String errorCode;
        if (e instanceof SecurityException) {
            errorCode = "ACCESS_DENIED";
        } else if (e instanceof FileNotFoundException) {
            errorCode = "NOT_SUPPORTED_FORMAT";
        } else if (e instanceof IOException && e.toString().contains("No space left on device")) {
            errorCode = "NOT_ENOUGH_SPACE";
        } else {
            errorCode = "UNEXPECTED";
        }
        sendError(errorCode, e.toString(), e.getStackTrace(), result);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
        activity = activityPluginBinding.getActivity();
        activityPluginBinding.addRequestPermissionsResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
        activity = activityPluginBinding.getActivity();
        activityPluginBinding.addRequestPermissionsResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        accessRequestResult.complete(
                grantResults[0] == PackageManager.PERMISSION_GRANTED && PERMISSION_REQUEST_CODE == requestCode);
        return true;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        pluginBinding = null;
    }
}
