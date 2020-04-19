//
//  MainViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var api: QueryService? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.api = QueryService()
        api?.getDocuments() { docs in }
    }
    
}
