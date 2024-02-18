//
//  ContentView.swift
//  remote_notification
//
//  Created by Siarhei Samoshyn on 18/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        VStack {
            Button {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
                    if allowed {
                        // register for remote push notification
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        print("Push notification allowed by user")
                    } else {
                        print("Error while requesting push notification permission. Error \(error)")
                    }
                }
            } label: {
                Text("Start notification")
            }
        }
        .padding()
    }
//    
//    func registerNotification() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
//                print("Permission granted: \(granted) ")
//                guard granted else { return }
//                getNotificationsSettings()
//            }
//    }
//    
//    func getNotificationsSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            //1
//            guard settings.authorizationStatus == .authorized else { return }
//            //2
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            return true
        }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
        print("Device push notification token - \(tokenString)")
    }
}

#Preview {
    ContentView()
}
