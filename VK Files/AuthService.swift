//
//  AuthService.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation
import VKSdkFramework


class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = "7411023"
    private let scope = ["offline", "docs"]
    private let vkSDK: VKSdk
    
    weak var delegate: AuthDelegate?
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appId)
        super.init()
        print("vk sdk init")
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func wakeUpSession() {
        VKSdk.wakeUpSession(scope) { (state, error) in
            switch state {
            case .initialized:
                print("Initialized")
                VKSdk.authorize(self.scope)
            case .authorized:
                print("Authorized")
                VKSdk.forceLogout()
                print("Log out")
            default:
                print("Error")
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            print("Token:")
            print(result.token.accessToken ?? "No string")
        } else {
            print("No token")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("auth failed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.presentAuth(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("captcha")
    }
}
