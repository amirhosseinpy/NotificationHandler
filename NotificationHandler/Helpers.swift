//
//  Helper.swift
//  NotificationHandler
//
//  Created by amirhossein on 4/27/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
class Helpers {

    static func notificatonFunc(_ message:String) {
    
        if #available(iOS 10.0, *){
            let notification = UNMutableNotificationContent()
            notification.title = "Notification Center"
            notification.body = "message"
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }else{
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.category = "wakeUpAlarms"
        notification.alertAction = "open"
        UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    
    static func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
}
