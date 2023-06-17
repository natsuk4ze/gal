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
            self.putVideo(path: args["path"]!) { _,error in
                if let error = error as NSError? {
                    result(self.handleError(error: error))
                }
                else{
                    result(nil)
                }
            }
        case "putImage":
            let args = call.arguments as![String: String]
            self.putImage(path: args["path"]!) { _, error in
                if let error = error as NSError? {
                    result(self.handleError(error: error))
                }
                else{
                    result(nil)
                }
            }
        case "open":
            self.open() {
                result(nil)
            }
        case "hasAccess":
            result(self.hasAccess())
        case "requestAccess":
            self.hasAccess() ? result(true) : self.requestAccess(completion: { granted in
                result(granted)
            })
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func putVideo(path: String, completion: @escaping (Bool, Error?) -> Void) {
        let videoURL = URL(fileURLWithPath: path)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }, completionHandler: completion)
    }
    
    private func putImage(path: String, completion: @escaping (Bool, Error?) -> Void) {
        let image = UIImage(contentsOfFile: path)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        }, completionHandler: completion)
    }
    
    private func open(completion: @escaping () -> Void) {
        guard let url = URL(string: "photos-redirect://") else { return }
        UIApplication.shared.open(url, options: [:]) { _ in completion() }
    }
    
    //For more info: https://qiita.com/fuziki/items/87a3a1a8e481a1546b38
    private func hasAccess() -> Bool {
        if #available(iOS 14, *){
            return PHPhotoLibrary.authorizationStatus(for:.addOnly) == .authorized
        }
        else{
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
        
    }
    
    //For more info: https://qiita.com/fuziki/items/87a3a1a8e481a1546b38
    private func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *){
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { _ in
                completion(PHPhotoLibrary.authorizationStatus(for:.addOnly) == .authorized)
            }
        }
        else{
            PHPhotoLibrary.requestAuthorization() { _ in
                completion(PHPhotoLibrary.authorizationStatus() == .authorized)
            }
        }
    }
    
    private func handleError(error: NSError) -> FlutterError{
        let message = error.localizedDescription
        let details = Thread.callStackSymbols
        if #available(iOS 15, *){
            switch error.code {
            case PHPhotosError.accessRestricted.rawValue, PHPhotosError.accessUserDenied.rawValue:
                return FlutterError(code:"ACCESS_DENIED",message:message,details:details)
            case PHPhotosError.identifierNotFound.rawValue, PHPhotosError.multipleIdentifiersFound.rawValue,
                PHPhotosError.requestNotSupportedForAsset.rawValue,3302:
                return FlutterError(code: "NOT_SUPPORTED_FORMAT",message:message,details:details)
            case PHPhotosError.notEnoughSpace.rawValue:
                return FlutterError(code: "NOT_ENOUGH_SPACE",message:message,details:details)
            default:
                return FlutterError(code: "UNEXPECTED",message:message,details:details)
            }
        }
        else{
            return FlutterError(code: "NOT_HANDLE",message:message,details:details)
        }
    }
}
