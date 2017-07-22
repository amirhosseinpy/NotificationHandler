//
//  NotificationCenterHandler.swift
//  NotificationHandler
//
//  Created by amirhossein on 4/27/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import UIKit
import BRYXBanner

class NotificationCenterHandler{
    let notification: [AnyHashable: Any]
    let appDelegate: AppDelegate
    let defaults = UserDefaults.standard
    
    init(notification:[AnyHashable:Any],appDelegate:AppDelegate) {
        self.notification = notification
        self.appDelegate = appDelegate
        validateNotification()
    }
    
    
    
    func validateNotification() {
        if  let notificationBody = notification["aps"] as? NSDictionary,
            let _ = notificationBody["alert"] as? String,
            let _ = notification["title"] as? String,
            let _ = notification["type"] as? String{
            notificationFunctionsByState()
        }else {
            print("Notification body has some problems!",notification)
            //            Helpers.notificatonFunc("Notification body has some problems!")
        }
        
    }
    
    
    
    //    enum types {
    //        case viewA(viewController: UIViewController)
    //        case viewB(viewController: UIViewController)
    //        case viewC(viewController: UIViewController)
    //        case viewD(viewController: UIViewController)
    //    }
    func notificationFunctionsByState() {
        let state = UIApplication.shared.applicationState
        switch state {
        case .active:
            activeFunctions()
        case .background:
            print("background")
            backgroundFunctions()
            //        case .inactive:
        //            inactiveFunction()
        default:
            backgroundFunctions()
        }
    }
    
    func activeFunctions() {
        let type = getNotificationType()
        switch type {
        case "ViewA":
            typeANotificationHandlerActive()
        case "ViewB":
            typeBNotificationHandlerActive()
        case "ViewC":
            typeCNotificationHandlerActive()
        default:
            typeANotificationHandlerActive()
        }
    }
    func backgroundFunctions(){
        let type = getNotificationType()
        switch type {
        case "ViewA":
            typeANotificationHandlerBackground()
        case "ViewB":
            typeBNotificationHandlerBackground()
        case "ViewC":
            typeCNotificationHandlerBackground()
        default:
            typeANotificationHandlerBackground()
        }
        
    }
    func inactiveFunction() {
        Helpers.runAfterDelay(1, block: notificationFunctionsByState)
    }
    
    func typeANotificationHandlerActive() {
        if notificationAndActiveAreTheSame(){
            let controller = UIApplication.topViewController() as! ViewControllerA
            controller.AButton.titleLabel?.text = "Anotification"
        }else {
            defaults.set("AButton", forKey: "Notification asset A")
            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
            banner.didTapBlock = {
                self.segueToA()
            }
            banner.show(duration: 3.0)
        }
    }
    
    func typeANotificationHandlerBackground(){
        defaults.set("AButton", forKey: "Notification asset A")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AVC = storyboard.instantiateViewController(withIdentifier: "ViewControllerA") as! ViewControllerA
        let navigationController = UINavigationController.init(rootViewController: AVC)
        appDelegate.window!.rootViewController = navigationController
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func typeBNotificationHandlerActive() {
        if notificationAndActiveAreTheSame(){
            let controller = UIApplication.topViewController() as! ViewControllerB
            controller.Bbutton.titleLabel?.text = "Bnotification"
        }else {
            defaults.set("BButton", forKey: "Notification asset B")
            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
            banner.didTapBlock = {
                self.segueToB()
            }
            banner.show(duration: 3.0)
        }
    }
    
    func typeBNotificationHandlerBackground(){
        
        defaults.set("BButton", forKey: "Notification asset B")
        
        //        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let mainFeedVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewControllerA") as! UINavigationController
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AVC = storyboard.instantiateViewController(withIdentifier: "ViewControllerA") as! ViewControllerA
        let navigationController = UINavigationController.init(rootViewController: AVC)
        let viewControllerB:ViewControllerB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB
        navigationController.pushViewController(viewControllerB, animated: false)
        appDelegate.window!.rootViewController = navigationController
        appDelegate.window!.makeKeyAndVisible()
        
        
    }
    
    func typeCNotificationHandlerActive() {
        if notificationAndActiveAreTheSame(){
            let controller = UIApplication.topViewController() as! ViewControllerC
            controller.CButton.titleLabel?.text = "Cnotification"
        }else {
            defaults.set("CButton", forKey: "Notification asset C")
            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
            banner.didTapBlock = {
                self.segueToC()
            }
            banner.show(duration: 3.0)
        }
        
    }
    
    func typeCNotificationHandlerBackground(){
        defaults.set("CButton", forKey: "Notification asset C")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AVC = storyboard.instantiateViewController(withIdentifier: "ViewControllerA") as! ViewControllerA
        let navigationController = UINavigationController.init(rootViewController: AVC)
        let viewControllerB:ViewControllerB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB
        let viewControllerC:ViewControllerC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerC") as! ViewControllerC
        navigationController.pushViewController(viewControllerB, animated: false)
        navigationController.pushViewController(viewControllerC, animated: false)
        appDelegate.window!.rootViewController = navigationController
        appDelegate.window!.makeKeyAndVisible()
        
    }
    
    func getNotificationTitle() -> String {
        //        let notificationBody = notification["aps"] as? NSDictionary
        return (notification["title"] as? String)!
    }
    func getClubsName() -> String {
        return (notification["clubName"] as? String)!
    }
    func getNotificationType() -> String{
        return (notification["type"] as? String)!
    }
    
    func notificationAndActiveAreTheSame() -> Bool {
        if let _ = UIApplication.topViewController(){
            if (UIApplication.topViewController()?.isKind(of: ViewControllerA.self))!
                && (getNotificationType()=="ViewA"){
                return true
            }else if (UIApplication.topViewController()?.isKind(of: ViewControllerB.self))!
                && (getNotificationType()=="ViewB")  {
                return true
            }else if (UIApplication.topViewController()?.isKind(of: ViewControllerC.self))!
                && (getNotificationType()=="ViewC")  {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    func segueToA(){
        if UIApplication.topViewController() != nil{
            while !(UIApplication.topViewController()?.isKind(of: ViewControllerA.self))! {
                if let navigator = UIApplication.topViewController()?.navigationController {
                    navigator.popViewController(animated: false)
                }
            }
        }
    }
    
    func segueToB(){
        if let currentViewController = UIApplication.topViewController(){
            if (currentViewController .isKind(of: ViewControllerC.self)) ||
                (currentViewController .isKind(of: ViewControllerD.self)){
                while !(currentViewController.isKind(of: ViewControllerB.self)) {
                    UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
                }
            }else {
                let viewController:ViewControllerB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB
                if let navigator = UIApplication.topViewController()?.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        }
    }
    func segueToC() {
        if let currentViewController = UIApplication.topViewController(){
            
            if (currentViewController .isKind(of: ViewControllerD.self)){
                UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
            }else {
                if (currentViewController .isKind(of: ViewControllerA.self)){
                    
                    let viewControllerB:ViewControllerB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB
                    let viewControllerC:ViewControllerC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerC") as! ViewControllerC
                    
                    if let navigator = UIApplication.topViewController()?.navigationController {
                        navigator.pushViewController(viewControllerB, animated: false)
                        navigator.pushViewController(viewControllerC, animated: true)
                    }
                }else if (currentViewController .isKind(of: ViewControllerB.self)){
                    
                    let viewControllerC:ViewControllerC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerC") as! ViewControllerC
                    
                    if let navigator = UIApplication.topViewController()?.navigationController {
                        navigator.pushViewController(viewControllerC, animated: true)
                    }
                    
                }
                
            }
        }
    }
}
