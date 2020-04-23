//
//  SettingsViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit
import VKSdkFramework

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutAction(_ sender: Any) {
        VKSdk.forceLogout()
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInVC
    }
}
