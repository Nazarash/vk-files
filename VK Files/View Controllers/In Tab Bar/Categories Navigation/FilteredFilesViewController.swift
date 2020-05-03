//
//  FilteredFilesViewController.swift
//  VK Files
//
//  Created by Дмитрий on 03.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class FilteredFilesViewController: FilesContainingViewController {
    
    var category: DocType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.applyFilterWithType(type: category)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.applyFilterWithType(type: nil)
    }

}
