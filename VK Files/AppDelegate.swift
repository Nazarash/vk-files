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
    
    static func getInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        authService = AuthService()
        
        let loadingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoadingVC")
        window?.rootViewController = loadingVC
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }
}

