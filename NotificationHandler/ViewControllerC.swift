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
        // Do any additional setup after loading the view.
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
