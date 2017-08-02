//
//  ViewController.swift
//  NotificationHandler
//
//  Created by amirhossein on 4/26/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import UIKit

class ViewControllerA: UIViewController {
 let segue : String = "goToB"
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test name:",NSStringFromClass(type(of: self)))
        print("name:", Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? ?? "")
        let string = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String?
        let newString = string?.replacingOccurrences(of: " ", with: "_")
        print("display name:", newString ?? "")
        update()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
//        update()
    }
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    
    func update(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        guard let _ = appDelegate.getNotificationDataType() else {
            return
        }
        if let asset = defaults.string(forKey: Strings.getDefaultKeyByNotificationType(notificationType: appDelegate.getNotificationDataType()!)){
            AButton.setTitle(asset, for: .normal)
            defaults.set(nil, forKey: Strings.getDefaultKeyByNotificationType(notificationType: appDelegate.getNotificationDataType()!))
        }
    }
    
    @IBOutlet weak var AButton: UIButton!
    @IBAction func Abutton(_ sender: Any) {
         performSegue(withIdentifier: segue, sender: sender)
    }

}

