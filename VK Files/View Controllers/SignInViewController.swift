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
        
        authService = AppDelegate.getInstance().authService
        authService.delegate = self
    }

    @IBAction func signInAction(_ sender: Any) {
        VKSdk.authorize(authService.scope)
    }
}

extension SignInViewController: AuthDelegate {
    func authorizationFinished() {
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
    
    func authorizationFailed() {
        showErrorAlert(with: "Something went wrong with the authorization. Try again.")
    }
    
    func presentAuth(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}
