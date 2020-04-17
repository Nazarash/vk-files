//
//  AuthDelegate.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

protocol AuthDelegate: AnyObject {
    
    func presentAuth(viewController: UIViewController)
}
