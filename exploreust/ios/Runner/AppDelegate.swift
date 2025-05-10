import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("YAIzaSyCLTD_badYbt-EY9qA1nA_6QCz9-b8m8s8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
