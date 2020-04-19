//
//  SignInViewController.swift
//  VK Files
//
//  Created by Дмитрий on 16.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit
import VKSdkFramework

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        VKSdk.authorize(appDelegate.authService.scope)
    }
    
    
}

