//
//  LoadingViewController.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit
import VKSdkFramework

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        VKSdk.wakeUpSession(AuthService.shared.scope) { (state, error) in
            if state == .authorized {
                let tabBarController = UIViewController.initFromStoryboard(id: .TabBarController)
                AppDelegate.getInstance().window?.rootViewController = tabBarController
            } else {
                let signInVC = UIViewController.initFromStoryboard(id: .SignInVC)
                AppDelegate.getInstance().window?.rootViewController = signInVC
                if state == .error {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with: error?.localizedDescription ?? "Error without description")
                    }
                }
            }
        }
    }
}
