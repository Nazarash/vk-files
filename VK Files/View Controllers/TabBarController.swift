//
//  TabBarController.swift
//  VK Files
//
//  Created by Дмитрий on 03.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        injectDataManager()
    }
    
    func injectDataManager() {
        let dataManager = DataManager()
        for navigationController in children as! [UINavigationController] {
            if let dataPresenter = navigationController.children.first as? DataInjectable {
                dataPresenter.injectDataManager(dataManager)
            }
        }
    }
}
