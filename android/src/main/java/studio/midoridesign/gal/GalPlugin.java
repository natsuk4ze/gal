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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.CompletableFuture;

public class GalPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private FlutterPluginBinding pluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gal");
        channel.setMethodCallHandler(this);
        pluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("putVideo")) {
            String path = call.argument("path");
            CompletableFuture.runAsync(() -> {
                try {
                    putVideo(pluginBinding.getApplicationContext(), path);
                    new Handler(Looper.getMainLooper()).post(() -> result.success(null));
                } catch (IOException e) {
                    new Handler(Looper.getMainLooper())
                            .post(() -> result.error("IO_ERROR", "Failed to save video to gallery", null));
                }
            });
        } else if (call.method.equals("putImage")) {
            String path = call.argument("path");
            CompletableFuture.runAsync(() -> {
                try {
                    putImage(pluginBinding.getApplicationContext(), path);
                    new Handler(Looper.getMainLooper()).post(() -> result.success(null));
                } catch (IOException e) {
                    new Handler(Looper.getMainLooper())
                            .post(() -> result.error("IO_ERROR", "Failed to save image to gallery", null));
                }
            });
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        pluginBinding = null;
    }

    private void putVideo(Context context, String path) throws IOException {
        ContentResolver resolver = context.getContentResolver();
        ContentValues values = new ContentValues();
        File file = new File(path);

        values.put(MediaStore.Video.Media.DISPLAY_NAME, file.getName());
        values.put(MediaStore.Video.Media.DATE_TAKEN, System.currentTimeMillis());

        Uri videoUri = resolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, values);

        try (OutputStream out = resolver.openOutputStream(videoUri);
             InputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    private void putImage(Context context, String path) throws IOException {
        ContentResolver resolver = context.getContentResolver();
        ContentValues values = new ContentValues();
        File file = new File(path);

        values.put(MediaStore.Images.Media.DISPLAY_NAME, file.getName());
        values.put(MediaStore.Images.Media.DATE_TAKEN, System.currentTimeMillis());

        Uri imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);

        try (OutputStream out = resolver.openOutputStream(imageUri);
             InputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
