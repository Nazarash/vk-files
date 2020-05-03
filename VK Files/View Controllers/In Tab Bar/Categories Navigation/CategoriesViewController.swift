//
//  CategoriesViewController.swift
//  VK Files
//
//  Created by Дмитрий on 03.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocType.allCases.count
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let chosenType = DocType.allCases[indexPath.row]
        cell.titleLabel.text = chosenType.description
        cell.categoryImage.image = UIImage(systemName: chosenType.systemImageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryVC = UIViewController.initFromStoryboard(id: .FilteredVC) as! FilteredFilesViewController
        let chosenType = DocType.allCases[indexPath.row]
        categoryVC.title = chosenType.description
        categoryVC.defaultTitle = chosenType.description
        categoryVC.dataManager = dataManager
        categoryVC.category = chosenType
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}

extension CategoriesViewController: DataInjectable {
    
    func injectDataManager(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
