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
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appId)
        super.init()
        print("vk sdk init")
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("auth finished")
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("auth failed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("should present")
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("captcha")
    }
}
