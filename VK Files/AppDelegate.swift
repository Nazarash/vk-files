//
//  AppDelegate.swift
//  VK Files
//
//  Created by Дмитрий on 16.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit
import VKSdkFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var authService: AuthService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        authService = AuthService()
        authService.delegate = self
        
        let loadingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoadingVC")
        window?.rootViewController = loadingVC // Blank VC used only to wait for wakeUpSession completes
        
        VKSdk.wakeUpSession(authService.scope) { (state, error) in
            if state == .authorized {
                let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
                self.window?.rootViewController = tabBarController
            } else {
                let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInVC")
                self.window?.rootViewController = signInVC
                if state == .error {
                    print(error?.localizedDescription ?? "Error without description")
                }
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }
    
    
    
}

extension AppDelegate: AuthDelegate {
    func authorizationFinished() {
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
        self.window?.rootViewController = tabBarController
    }
    
    func authorizationFailed() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong with the authorization. Try again.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.window?.rootViewController?.present(alert, animated: true)
    }
    
    func presentAuth(viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    
}

