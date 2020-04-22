//
//  MainViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var api: QueryService!
    var documents = [VkDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        

        self.api = QueryService()
        api.getDocuments() { docs, errorMessage in
            if !errorMessage.isEmpty {
                self.tableView.isHidden = true
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if let docs = docs {
                self.tableView.isHidden = false
                self.documents = docs
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainDocumentCell.identifier, for: indexPath) as! MainDocumentCell
        cell.configure(with: documents[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80.0
    }
}
