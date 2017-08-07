//
//  ViewControllerC.swift
//  NotificationHandler
//
//  Created by amirhossein on 4/26/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import UIKit

class ViewControllerC: UIViewController {
    
    let segue : String = "goToD"

    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        // Do any additional setup after loading the view.
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
        if let asset = defaults.string(forKey: Strings.getDefaultKeyByNotificationType(notificationType: Strings.NotificationType.typeC.rawValue)){
            CButton.setTitle(asset, for: .normal)
            defaults.set(nil, forKey: Strings.getDefaultKeyByNotificationType(notificationType: Strings.NotificationType.typeC.rawValue))
        }
    }
    
    @IBOutlet weak var CButton: UIButton!
    @IBAction func CButton(_ sender: Any) {
        performSegue(withIdentifier: segue, sender: sender)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
