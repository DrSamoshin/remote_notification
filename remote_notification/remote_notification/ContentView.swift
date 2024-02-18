//
//  ContentView.swift
//  remote_notification
//
//  Created by Siarhei Samoshyn on 18/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button("Register Notification", action: requestAuthorization)
        }
        .padding()
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { allowed, error in
            if allowed {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                print("Push notification allowed by user")
            } else {
                if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
                
                print("Error while requesting push notification permission. Error \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
