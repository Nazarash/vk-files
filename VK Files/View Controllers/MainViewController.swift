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
    
    var queryService: QueryService!
    var documents = [VkDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.queryService = QueryService()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateContent()
    }
    
    func updateContent() {
        queryService.getDocuments() { result in
            switch result {
            case .success(let docs):
                self.documents = docs
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    func showRenameDialog(for document: VkDocument) {
        let renameAlert = UIAlertController(title: "Rename file", message: nil, preferredStyle: .alert)
        
        renameAlert.addTextField { (textField) in
            textField.text = document.title
        }
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let newName = renameAlert.textFields?[0].text {
                if newName.range(of: #".*\.[A-Za-z0-9]+"#, options: .regularExpression) != nil {
                    self.rename(document, newName: newName)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        renameAlert.addAction(confirmAction)
        renameAlert.addAction(cancelAction)
        
        present(renameAlert, animated: true)
    }
    
    func showDeleteDialog(for document: VkDocument) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delete(document)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(confirmAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true)
    }
    
    func rename(_ document: VkDocument, newName: String) {
        queryService.renameDocument(id: document.id, newName: newName) { result in
            switch result {
            case .success:
                self.updateContent()
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    func delete(_ document: VkDocument) {
        queryService.deleteDocument(id: document.id) { result in
            switch result {
            case .success:
                self.updateContent()
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: "\(indexPath.row)" as NSString, previewProvider: nil) { _ in

            let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { _ in
                self.showRenameDialog(for: self.documents[indexPath.row])
            }
            
            let removeAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) {_ in
                self.showDeleteDialog(for: self.documents[indexPath.row])
            }
            
            return UIMenu(title: "", image: nil, children: [renameAction, removeAction])
        }
    }
    
}
