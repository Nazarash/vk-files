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
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        authService = appDelegate.authService
    }

    @IBAction func signInAction(_ sender: Any) {
        VKSdk.authorize(authService.scope)
    }
    
    
}

