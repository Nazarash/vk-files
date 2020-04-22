//
//  MainDocumentCell.swift
//  VK Files
//
//  Created by Дмитрий on 22.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainDocumentCell: UITableViewCell {
    
    static let identifier = "MainDocumentCell"
    
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    
    func configure(with document: VkDocument) {
        previewImage.image = UIImage(systemName: document.systemImageName)
        titleLabel.text = document.title
        detailsLabel.text = document.approximateSize
    }

}
