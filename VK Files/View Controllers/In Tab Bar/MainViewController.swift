//
//  MainViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainViewController: FilesContainingViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        defaultTitle = "My Files"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search files"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.updateData()
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        dataManager.applyFilterWithSearch(text: searchController.searchBar.text!)
    }
}
