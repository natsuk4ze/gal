import Flutter
import UIKit
import Photos

public class GalPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gal", binaryMessenger: registrar.messenger())
        let instance = GalPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "putVideo":
            let args = call.arguments as![String: String]
            self.putVideo(path: args["path"]!) { saved in
                result(saved)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func putVideo(path: String, completion: @escaping (Bool) -> Void) {
        let videoURL = URL(fileURLWithPath: path)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { saved, _ in
            completion(saved)
        }
    }
}
