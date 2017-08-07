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
    var direction:[String: String] //[notificationType: direction]
    //var StoryboardId:[String: String] //[notificationType: StoryBoardID]
    
    init(notification:[AnyHashable:Any],appDelegate:AppDelegate,direction:[String: String]/*,StoryboardId: [String: String]*/) {
        self.notification = notification
        self.appDelegate = appDelegate
        self.direction = direction
        validateNotification()
    }
    
    
    
    func validateNotification() {
        if  let notificationBody = notification[Strings.notificationKeys.apn.rawValue] as? NSDictionary,
            let _ = notificationBody[Strings.notificationKeys.alert.rawValue] as? String,
            let _ = notification[Strings.notificationKeys.title.rawValue] as? String,
            let _ = notification[Strings.notificationKeys.type.rawValue] as? String{
            notificationFunctionsByState()
        }else {
            print(Strings.NotificationProblem,notification)
        }
        
    }
    func notificationFunctionsByState() {
        let state = UIApplication.shared.applicationState
        if state == .active{
            activeStateNotificationFunction()
        }else{
           backgroundStateNotificationFunction()
        }
    }
    
    func activeStateNotificationFunction() {
        defaults.set(getClubsName(), forKey: Strings.getDefaultKeyByNotificationType(notificationType: getNotificationType()))
        if notificationAndActiveAreTheSame(){
            UIApplication.topViewController()?.viewDidAppear(false)
        }else {
            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
            banner.didTapBlock = {
                self.segue()
            }
            banner.show(duration: 3.0)
        }
    }
    
    func backgroundStateNotificationFunction() {
        defaults.set(getClubsName(), forKey: Strings.getDefaultKeyByNotificationType(notificationType: getNotificationType()))
        if let controllersName = getDirectionControllersName(){
            
            let viewController = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: controllersName[0])
            let navigationController = UINavigationController.init(rootViewController: viewController)
            for i in 1..<controllersName.count {
            let viewController = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: controllersName[i])
            navigationController.pushViewController(viewController, animated: false)
            }
            appDelegate.window!.rootViewController = navigationController
            appDelegate.window!.makeKeyAndVisible()
        }
    }
    
    
    func getNotificationTitle() -> String {
        //        let notificationBody = notification["aps"] as? NSDictionary
        return (notification[Strings.notificationKeys.title.rawValue] as? String)!
    }
    func getClubsName() -> String {
        return (notification[Strings.notificationKeys.clubName.rawValue] as? String)!
    }
    func getNotificationType() -> String{
        return (notification[Strings.notificationKeys.type.rawValue] as? String)!
    }
    
    func notificationAndActiveAreTheSame() -> Bool {
        if let _ = UIApplication.topViewController(){
            
            if (UIApplication.topViewController()?.isKind(of: getTargetViewControllerType()!))!{
                return true
            }
            
        }
        return false
    }
    
    
    func segue(){
        let indexOfCurrent = getIndexOfCurrentViewController()
        guard indexOfCurrent != -1 else {
            return
        }
        if let controllersName = getDirectionControllersName() {
            if (controllersName.count) - 1 < indexOfCurrent {
                popViewControllers(currentindex: indexOfCurrent, controllersName: controllersName)
            }else {
                pushViewControllers(currentIndex: indexOfCurrent, controllersName: controllersName)
            }
        }
    }
    
    func getIndexOfCurrentViewController() -> Int {
        if let currentViewController = UIApplication.topViewController(),
          let navigation = currentViewController.navigationController {
            return navigation.viewControllers.count-1
        }
        return -1
    }
    
    func popViewControllers(currentindex: Int, controllersName: [String]){
        if let _ = UIApplication.topViewController(){
            for _ in ((controllersName.count-1)..<currentindex){
                UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func pushViewControllers(currentIndex: Int, controllersName:[String]){
        for i in (currentIndex+1) ..< controllersName.count {
            let viewController = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: controllersName[i])
            if let navigator = UIApplication.topViewController()?.navigationController {
                navigator.pushViewController(viewController, animated: false)
            }
        }
    }
    
    func getDirectionArray() -> [UIViewController]? {
        
        var controllers :[UIViewController] = []
        let controllerString = direction[getNotificationType()]
        if let splittedStringControllers = controllerString?.components(separatedBy: "->"){
            for stringController in splittedStringControllers {
                if let aClass = swiftClassFromString(className: stringController) as? UIViewController.Type {
                    controllers.append(aClass.init())
                }
            }
            return controllers
        }
        return nil
    }
    
    func getTargetViewControllerType() -> UIViewController.Type? {
        print("view controller name:",String(describing: ViewControllerA.self))
        var controllers :[UIViewController.Type] = []
        let controllerString = direction[getNotificationType()]
        if let splittedStringControllers = controllerString?.components(separatedBy: "->"){
            for stringController in splittedStringControllers {
                if let aClass = swiftClassFromString(className: stringController) as? UIViewController.Type {
                    controllers.append(aClass)
                }
            }
            return controllers[controllers.count-1]
        }
        return nil
    }
    func getDirectionControllersName() -> [String]? {
        let controllerString = direction[getNotificationType()]
        if let splittedStringControllers = controllerString?.components(separatedBy: "->"){
            return splittedStringControllers
        }
        return nil
    }
    func getViewControllerTypeByName(controllerName : String) -> UIViewController.Type? {
        if let aClass = swiftClassFromString(className: controllerName) as? UIViewController.Type {
            return aClass
        }
        return nil
    }
    func getViewControllerByName(controllerName : String) -> UIViewController? {
        if let aClass = swiftClassFromString(className: controllerName) as? UIViewController.Type {
            return aClass.init()
        }
        return nil
    }
    
    func getTargetViewController() -> UIViewController?{
        if let controllers = getDirectionArray(){
            return controllers[controllers.count-1]
        }
        return nil
    }
    
    
    func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let fixedAppName = appName.replacingOccurrences(of: " ", with: "_")
            let classStringName = fixedAppName + "." + className
            print("class name:",classStringName)
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}

