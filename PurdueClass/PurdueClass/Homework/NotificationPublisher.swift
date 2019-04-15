
//
//  NotificationPublisher.swift
//  PurdueClass
//
//  Created by Dayu Liu on 3/22/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationPublisher : NSObject{
    
    func sendNotification(title: String,
                          subtitle: String,
                          body: String,
                          badge: Int?,
                          delayInterval: Int?){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval{
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
            
        }
        
        if let badge = badge{
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            
        }
        
        
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        
        let request = UNNotificationRequest(identifier: "TestLocationNotification", content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request){error in
            if let error = error {
                print (error.localizedDescription)
            }
        }
    }
}

extension NotificationPublisher : UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        completionHandler([.badge, .sound, .alert])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        
        switch identifier{
        case UNNotificationDismissActionIdentifier:
            print("The notification was dismissed")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("user opened app from the notification")
            completionHandler()
        default:
            print("default case was called")
            completionHandler()
        }
    }
}
