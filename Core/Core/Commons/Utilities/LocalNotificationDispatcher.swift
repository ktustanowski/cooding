//
//  LocalNotificationDispatcher.swift
//  Core
//
//  Created by Semerkchet on 21/04/2020.
//  Copyright © 2020 Kamil Tustanowski. All rights reserved.
//

import Foundation
import UserNotifications

protocol LocalNotificationDispatching {
    func askForPermission(completion: ((Bool) -> Void)?)
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, completion: ((Bool) -> Void)?)
    func cancelAll()
}

struct NotificationDispatcher: LocalNotificationDispatching {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func askForPermission(completion: ((Bool) -> Void)?) {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { userDidApprove, _ in
            completion?(userDidApprove)
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, completion: ((Bool) -> Void)?) {
        let notificationContent = UNMutableNotificationContent()
         notificationContent.title = title
         notificationContent.body = body
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                         repeats: false)
         let request = UNNotificationRequest(identifier: "notification",
                                             content: notificationContent,
                                             trigger: trigger)
        
         userNotificationCenter.add(request) { error in
            completion?(error == nil)
        }
    }
    
    func cancelAll() {
        userNotificationCenter.removeAllDeliveredNotifications()
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
