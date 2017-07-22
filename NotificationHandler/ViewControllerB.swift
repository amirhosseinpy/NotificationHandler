//
//  ViewControllerB.swift
//  NotificationHandler
//
//  Created by amirhossein on 4/26/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {

     let segue : String = "goToC"
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
   
    func update(){
        let defaults = UserDefaults.standard
        let asset = defaults.string(forKey: "Notification asset B")
        if asset != nil{
            Bbutton.setTitle(asset, for: .normal)
            defaults.set(nil, forKey: "Notification asset B")
        }
        
    }

    @IBOutlet weak var Bbutton: UIButton!
    @IBAction func BButton(_ sender: Any) {
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
