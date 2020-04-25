//
//  UIImageView.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(from imageURL: String) {
        let url = URL(string: imageURL)!
        if let data = try? Data(contentsOf: url) {
            self.image = UIImage(data: data)
        }
    }
}
