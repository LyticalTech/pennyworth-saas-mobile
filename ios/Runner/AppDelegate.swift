import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//
//    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if let incomingURL = userActivity.webpageURL {
//            print("Incoming URL is: \(incomingURL)")
//            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { link, error in
//                guard error == nil else {
//                    print("Found an error! \(error!.localizedDescription)")
//                    return
//                }
//                if let dynamicLink = link {
//                    self.handleIncomingDynamicLink(dynamicLink)
//                }
//            }
//            return linkHandled
//        }
//        return false
//    }
    
//    private func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
//        guard let url = dynamicLink.url else {
//            print("There's no url in the dynamic link!")
//            return
//        }
//
//        print("Your incoming link parameter is \(url.absoluteString)")
//    }
//
//    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        print("I have received a URL through a custom scheme: \(url.absoluteString)")
//
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//            self.handleIncomingDynamicLink(dynamicLink)
//            return true
//        } else {
//            return false
//        }
//    }
}
