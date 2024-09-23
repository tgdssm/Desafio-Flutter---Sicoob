import UIKit
import Flutter
import AudioToolbox

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let vibrationChannel = FlutterMethodChannel(name: "pokedex/vibration",
                                              binaryMessenger: controller.binaryMessenger)

    vibrationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "vibrate" {
        self.vibrateDevice()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func vibrateDevice() {
    debugPrint("vibrou")
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }
}
