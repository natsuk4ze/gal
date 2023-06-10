package studio.midoridesign.gal;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.content.Intent;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.core.content.ContextCompat;
import androidx.core.app.ActivityCompat;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;
import android.app.Activity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.CompletableFuture;

public class GalPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
    private MethodChannel channel;
    private FlutterPluginBinding pluginBinding;
    private static final String PERMISSION = Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private static final int PERMISSION_REQUEST_CODE = 1317298;
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
            String path = call.argument("path");
            Uri contentUri = call.method.equals("putVideo") ? MediaStore.Video.Media.EXTERNAL_CONTENT_URI : MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

            CompletableFuture.runAsync(() -> {
                try {
                    putMedia(pluginBinding.getApplicationContext(), path, contentUri);
                    new Handler(Looper.getMainLooper()).post(() -> result.success(null));
                } 
                catch (SecurityException e) {
                    new Handler(Looper.getMainLooper())
                            .post(() -> result.error("ACCESS_DENIED", null, null));
                }
                catch (FileNotFoundException e) {
                    new Handler(Looper.getMainLooper())
                            .post(() -> result.error("NOT_SUPPORTED_FORMAT", null, null));
                }
                catch (IOException e) {
                    String message = e.getMessage();
                    if (message != null && message.contains("No space left on device")) {
                        new Handler(Looper.getMainLooper())
                            .post(() -> result.error("NOT_ENOUGH_SPACE", null, null));
                    } else {
                        new Handler(Looper.getMainLooper())
                            .post(() -> result.error("UNEXPECTED", null, null));
                    }            
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
            result.success(hasAccess());
            break;
        }
        case "requestAccess": {
            if (hasAccess()) {
                result.success(true);
                return;
            } 
            accessRequestResult = new CompletableFuture<>();
            ActivityCompat.requestPermissions(activity, new String[]{PERMISSION}, PERMISSION_REQUEST_CODE);
            accessRequestResult.thenAccept(result::success);
            break;
        }
        default: {
            result.notImplemented();
        }
    }
    }

    private void putMedia(Context context, String path, Uri contentUri) throws IOException, SecurityException, FileNotFoundException {
        ContentResolver resolver = context.getContentResolver();
        ContentValues values = new ContentValues();
        File file = new File(path);

        values.put(MediaStore.MediaColumns.DISPLAY_NAME, file.getName());
        values.put(MediaStore.MediaColumns.DATE_ADDED, System.currentTimeMillis());

        Uri mediaUri = resolver.insert(contentUri, values);

        try (OutputStream out = resolver.openOutputStream(mediaUri);
             InputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    private void open(){
        Context context = pluginBinding.getApplicationContext();
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setType("image/*");
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    // When API >=29,<23 always true.
    private boolean hasAccess() {
        Context context = pluginBinding.getApplicationContext();
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            return true;
        }
        int hasAccess = ContextCompat.checkSelfPermission(context, PERMISSION);
        return hasAccess == PackageManager.PERMISSION_GRANTED;
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
        accessRequestResult.complete(grantResults[0] == PackageManager.PERMISSION_GRANTED && PERMISSION_REQUEST_CODE == requestCode);
        return true;   
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        pluginBinding = null;
    }
}
