//
//  SortMethodsViewController.swift
//  VK Files
//
//  Created by Дмитрий on 29.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class SortMethodsViewController: UITableViewController {
    
    var dataManager: DataManager!
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 120, height: tableView.contentSize.height)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SortMethods.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortMethodCell", for: indexPath)
        cell.textLabel?.text = SortMethods.allCases[indexPath.row].rawValue
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        dataManager.applySortMethod(SortMethods.allCases[indexPath.row])
    }
}
