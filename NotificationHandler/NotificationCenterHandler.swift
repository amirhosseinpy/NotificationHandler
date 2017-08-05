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
       // self.StoryboardId = StoryboardId
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
        if state == .active{
            activeStateNotificationFunction()
        }else{
           backgroundStateNotificationFunction()
        }
//        switch state {
//        case .active:
//            activeStateNotificationFunction()
//            //activeFunctions()
//        case .background:
//            backgroundStateNotificationFunction()
////            backgroundFunctions()
//            //        case .inactive:
//        //            inactiveFunction()
//        default:
//            backgroundStateNotificationFunction()
////            backgroundFunctions()
//        }
    }
    
//    func activeFunctions() {
//        let type = getNotificationType()
//        switch type {
//        case Strings.NotificationType.typeA.rawValue:
//            typeANotificationHandlerActive()
//        case Strings.NotificationType.typeB.rawValue:
//            typeBNotificationHandlerActive()
//        case Strings.NotificationType.typeC.rawValue:
//            typeCNotificationHandlerActive()
//        default:
//            typeANotificationHandlerActive()
//        }
        
//    }
//    func backgroundFunctions(){
//        let type = getNotificationType()
//        switch type {
//        case Strings.NotificationType.typeA.rawValue:
//            typeANotificationHandlerBackground()
//        case Strings.NotificationType.typeB.rawValue:
//            typeBNotificationHandlerBackground()
//        case Strings.NotificationType.typeC.rawValue:
//            typeCNotificationHandlerBackground()
//        default:
//            typeANotificationHandlerBackground()
//        }
//        backgroundStateNotificationFunction()
//    }
    //    func inactiveFunction() {
    //        Helpers.runAfterDelay(1, block: notificationFunctionsByState)
    //    }
    
    func activeStateNotificationFunction() {
        if notificationAndActiveAreTheSame(){
            defaults.set(getClubsName(), forKey: Strings.getDefaultKeyByNotificationType(notificationType: getNotificationType()))
            UIApplication.topViewController()?.viewDidAppear(false)
        }else {
            defaults.set(Strings.DefaultAString, forKey: Strings.DefaultAkey)
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
    
    
//    func typeANotificationHandlerActive() {
//        if notificationAndActiveAreTheSame(){
//            let controller = UIApplication.topViewController() as! ViewControllerA
//            controller.AButton.titleLabel?.text = Strings.DefaultAString
//        }else {
//            defaults.set(Strings.DefaultAString, forKey: Strings.DefaultAkey)
//            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
//            banner.didTapBlock = {
//                self.segueToA()
//            }
//            banner.show(duration: 3.0)
//        }
//    }
//    
//    func typeANotificationHandlerBackground(){
//        defaults.set(Strings.DefaultAString, forKey: Strings.DefaultAkey)
//        let storyboard: UIStoryboard = UIStoryboard(name: Strings.StoryBoardName, bundle: nil)
//        let AVC = storyboard.instantiateViewController(withIdentifier: Strings.ViewControllerA) as! ViewControllerA
//        let navigationController = UINavigationController.init(rootViewController: AVC)
//        appDelegate.window!.rootViewController = navigationController
//        appDelegate.window!.makeKeyAndVisible()
//    }
//    
//    func typeBNotificationHandlerActive() {
//        if notificationAndActiveAreTheSame(){
//            let controller = UIApplication.topViewController() as! ViewControllerB
//            controller.Bbutton.titleLabel?.text = Strings.DefaultBString
//        }else {
//            defaults.set(Strings.DefaultBString, forKey: Strings.DefaultBkey)
//            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
//            banner.didTapBlock = {
//                self.segueToB()
//            }
//            banner.show(duration: 3.0)
//        }
//    }
//    
//    func typeBNotificationHandlerBackground(){
//        
//        defaults.set(Strings.DefaultBString, forKey: Strings.DefaultBkey)
//        
//        //        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        //        let mainFeedVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewControllerA") as! UINavigationController
//        let storyboard: UIStoryboard = UIStoryboard(name: Strings.StoryBoardName, bundle: nil)
//        let AVC = storyboard.instantiateViewController(withIdentifier: Strings.ViewControllerA) as! ViewControllerA
//        let navigationController = UINavigationController.init(rootViewController: AVC)
//        let viewControllerB:ViewControllerB = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerB) as! ViewControllerB
//        navigationController.pushViewController(viewControllerB, animated: false)
//        appDelegate.window!.rootViewController = navigationController
//        appDelegate.window!.makeKeyAndVisible()
//        
//        
//    }
//    
//    func typeCNotificationHandlerActive() {
//        if notificationAndActiveAreTheSame(){
//            print("are the same")
//            let controller = UIApplication.topViewController() as! ViewControllerC
//            controller.CButton.titleLabel?.text = Strings.DefaultCString
//        }else {
//            defaults.set(Strings.DefaultCString, forKey: Strings.DefaultCkey)
//            let banner = Banner(title: getClubsName(), subtitle: getNotificationTitle(), image: nil, backgroundColor: UIColor.black)
//            banner.didTapBlock = {
//                self.segueToC()
//            }
//            banner.show(duration: 3.0)
//        }
//        
//    }
//    
//    func typeCNotificationHandlerBackground(){
//        defaults.set(Strings.DefaultCString, forKey: Strings.DefaultCkey)
//        let storyboard: UIStoryboard = UIStoryboard(name: Strings.StoryBoardName, bundle: nil)
//        let AVC = storyboard.instantiateViewController(withIdentifier: Strings.ViewControllerA) as! ViewControllerA
//        let navigationController = UINavigationController.init(rootViewController: AVC)
//        let viewControllerB:ViewControllerB = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerB) as! ViewControllerB
//        let viewControllerC:ViewControllerC = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerC) as! ViewControllerC
//        navigationController.pushViewController(viewControllerB, animated: false)
//        navigationController.pushViewController(viewControllerC, animated: false)
//        appDelegate.window!.rootViewController = navigationController
//        appDelegate.window!.makeKeyAndVisible()
//        
//    }
    
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
            //            if (UIApplication.topViewController()?.isKind(of: ViewControllerA.self))!
            //                && (getNotificationType()==Strings.NotificationType.typeA.rawValue){
            //                return true
            //            }else if (UIApplication.topViewController()?.isKind(of: ViewControllerB.self))!
            //                && (getNotificationType()==Strings.NotificationType.typeB.rawValue)  {
            //                return true
            //            }else if (UIApplication.topViewController()?.isKind(of: ViewControllerC.self))!
            //                && (getNotificationType()==Strings.NotificationType.typeC.rawValue)  {
            //                return true
            //            }else {
            //                return false
            //            }
            
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
//            for (index, controller) in controllersName.enumerated() {
//                if let viewController = getViewControllerTypeByName(controllerName: controller){
//                    if (currentViewController.isKind(of: viewController)){
//                        return index
//                    }
//                }
//            }
            
            return navigation.viewControllers.count-1
        }
        return -1
    }
    
    func popViewControllers(currentindex: Int, controllersName: [String]){
        if let _ = UIApplication.topViewController(){
//            while !(currentViewController.isKind(of: targetControllerType)){
            for _ in ((controllersName.count-1)..<currentindex){
           // print("number of view controllers:",currentViewController.navigationController?.viewControllers.count ?? "")
            //for _ in 1...3 {
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
    
    
    
//    func segueToA(){
//        if UIApplication.topViewController() != nil{
//            while !(UIApplication.topViewController()?.isKind(of: ViewControllerA.self))! {
//                if let navigator = UIApplication.topViewController()?.navigationController {
//                    navigator.popViewController(animated: false)
//                }
//            }
//        }
//    }
    
   
    
//    func segueToB(){
//        if let currentViewController = UIApplication.topViewController(){
//            if (currentViewController .isKind(of: ViewControllerC.self)) ||
//                (currentViewController .isKind(of: ViewControllerD.self)){
//                while !(currentViewController.isKind(of: ViewControllerB.self)) {
//                    UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
//                }
//            }else {
//                let viewController:ViewControllerB = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerB) as! ViewControllerB
//                if let navigator = UIApplication.topViewController()?.navigationController {
//                    navigator.pushViewController(viewController, animated: true)
//                }
//            }
//            
//        }
//    }
//    func segueToC() {
//        if let currentViewController = UIApplication.topViewController(){
//            
//            if (currentViewController .isKind(of: ViewControllerD.self)){
//                UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
//            }else {
//                if (currentViewController .isKind(of: ViewControllerA.self)){
//                    
//                    let viewControllerB:ViewControllerB = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerB) as! ViewControllerB
//                    let viewControllerC:ViewControllerC = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerC) as! ViewControllerC
//                    
//                    if let navigator = UIApplication.topViewController()?.navigationController {
//                        navigator.pushViewController(viewControllerB, animated: false)
//                        navigator.pushViewController(viewControllerC, animated: true)
//                    }
//                }else if (currentViewController .isKind(of: ViewControllerB.self)){
//                    
//                    let viewControllerC:ViewControllerC = UIStoryboard(name: Strings.StoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Strings.ViewControllerC) as! ViewControllerC
//                    
//                    if let navigator = UIApplication.topViewController()?.navigationController {
//                        navigator.pushViewController(viewControllerC, animated: true)
//                    }
//                    
//                }
//                
//            }
//        }
//    }
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
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            //            let classStringName = "_TtC\(appName.utf16.count)\(appName)\(className.characters.count)\(className)"
            // return the class!
            let fixedAppName = appName.replacingOccurrences(of: " ", with: "_")
            let classStringName = fixedAppName + "." + className
            print("class name:",classStringName)
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}

