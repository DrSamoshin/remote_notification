//
//  NotificationProcessor.swift
//  remote_notification
//
//  Created by Kanstantsin Ausianovich on 19.02.24.
//

import Foundation
import UIKit

actor NotificationProcessor {
    
    static let shared: NotificationProcessor = {
        let instance = NotificationProcessor()
        
        return instance
    }()
    
    let options: UNNotificationPresentationOptions = [.list, .badge, .sound, .banner]
    
    private init() {}
    
    func setDelegate(_ delegate: UNUserNotificationCenterDelegate) {
        UNUserNotificationCenter.current().delegate = delegate
    }
    
    enum AuthorizationOptions {
        case common
        case provisional
        
        var parameters: UNAuthorizationOptions {
            switch self {
            case .common:
                return [.alert, .sound, .badge]
            case .provisional:
                return [.provisional, .alert, .sound, .badge]
            }
        }
    }
    
    @MainActor
    func requestAuthorization(_ options: AuthorizationOptions = .common) async throws {
        let center = UNUserNotificationCenter.current()
        let allowed = try await center.requestAuthorization(options: options.parameters)
        
        if allowed {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            guard let url = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
            await UIApplication.shared.open(url)
        }
    }
    
    @MainActor
    func processNotificationSettings() async throws {
        let center = UNUserNotificationCenter.current()
        let status = await center.notificationSettings().authorizationStatus
        
        switch status {
        case .notDetermined:
            try await requestAuthorization(.provisional)
        case .denied:
            UIApplication.shared.unregisterForRemoteNotifications()
        case .authorized, .provisional, .ephemeral:
            UIApplication.shared.registerForRemoteNotifications()
        @unknown default:
            break
        }
    }
    
    @MainActor
    var shouldSendToSettings: Bool {
        get async {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            return settings.badgeSetting == .disabled || settings.alertSetting == .disabled || settings.soundSetting == .disabled || settings.lockScreenSetting == .disabled
        }
    }
}
