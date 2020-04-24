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

        VKSdk.wakeUpSession(AppDelegate.getInstance().authService.scope) { (state, error) in
            if state == .authorized {
                let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
                UIApplication.shared.keyWindow?.rootViewController =  tabBarController
            } else {
                let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInVC")
                UIApplication.shared.keyWindow?.rootViewController =  signInVC
                if state == .error {
                    print(error?.localizedDescription ?? "Error without description")
                }
            }
        }
    }
}
