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
    
    var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService = AuthService.shared
        authService.delegate = self
    }

    @IBAction func signInAction(_ sender: Any) {
        VKSdk.authorize(authService.scope)
    }
}

extension SignInViewController: AuthDelegate {
    
    func authorizationFinished() {
        let tabBarController = UIViewController.initFromStoryboard(id: .TabBarController)
        AppDelegate.getInstance().window?.rootViewController = tabBarController
    }
    
    func authorizationFailed() {
        showAlert(with: "Something went wrong with the authorization. Try again.")
    }
    
    func presentAuth(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}
