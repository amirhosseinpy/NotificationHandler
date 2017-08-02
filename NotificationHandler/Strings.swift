//
//  String.swift
//  NotificationHandler
//
//  Created by amirhossein on 5/10/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import Foundation
struct Strings {
    enum NotificationType : String {
        case typeA = "ViewA"
        case typeB = "ViewB"
        case typeC = "ViewC"
        case typeD = "ViewD"
    }
    enum notificationKeys : String {
        case apn = "aps"
        case alert = "alert"
        case title = "title"
        case type = "type"
        case clubName = "clubName"
    }
    static let NotificationProblem = "Notification body has some problems!"
    
    static let Defaultkey = "notification_asset_"
    
    static let DefaultAkey = "Notification asset A"
    static let DefaultAString = "AButton"
    static let ViewControllerA = "ViewControllerA"
    
    static let DefaultBkey = "Notification asset B"
    static let DefaultBString = "BButton"
    static let ViewControllerB = "ViewControllerB"
    
    static let DefaultCkey = "Notification asset C"
    static let DefaultCString = "CButton"
    static let ViewControllerC = "ViewControllerC"
    
    static let StoryBoardName = "Main"
    
    
    static func getDefaultKeyByNotificationType(notificationType: String) -> String{
        return Defaultkey + notificationType
    }
}
