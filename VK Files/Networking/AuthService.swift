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
    
    let appId = "7411023"
    let scope = ["offline", "docs"]
    private let vkSDK: VKSdk
    
    weak var delegate: AuthDelegate?
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authorizationFinished()
        } else {
            delegate?.authorizationFailed()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authorizationFailed()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.presentAuth(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("captcha!")
    }
}
