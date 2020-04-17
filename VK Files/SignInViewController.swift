//
//  SignInViewController.swift
//  VK Files
//
//  Created by Дмитрий on 16.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService = AppDelegate.shared().authService
    }

    @IBAction func signInAction(_ sender: Any) {
        authService.wakeUpSession()
    }
    
    
}

