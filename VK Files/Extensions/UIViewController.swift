//
//  UIViewController.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func initFromStoryboard(id: StoryboardID) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: id.rawValue)
    }
    
    func showErrorAlert(with errorText: String) {
        let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
