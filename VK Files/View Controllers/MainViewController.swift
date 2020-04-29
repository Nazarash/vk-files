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
    @IBOutlet weak var sortButton: UIBarButtonItem!
    

    var documentInteractionController: UIDocumentInteractionController!
    
    var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = DataManager()
        
        tableView.delegate = self
        tableView.dataSource = dataManager
        
        documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.delegate = self
        
        dataManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataManager.updateContent()
    }
    
    func showRenameDialog(forCellatRow index: Int) {
        let renameAlert = UIAlertController(title: "Rename file", message: nil, preferredStyle: .alert)
        
        renameAlert.addTextField { (textField) in
            textField.text = self.dataManager.getDocument(withIndex: index).title
        }
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let newName = renameAlert.textFields?[0].text {
                if newName.range(of: #".*\.[A-Za-z0-9]+"#, options: .regularExpression) != nil {
                    self.dataManager.renameDocument(withIndex: index, newName: newName)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        renameAlert.addAction(confirmAction)
        renameAlert.addAction(cancelAction)
        
        present(renameAlert, animated: true)
    }
    
    func showDeleteDialog(forCellatRow index: Int) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.dataManager.deleteDocument(withIndex: index)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(confirmAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true)
    }
    
    func showActivityVC(forCellAt indexPath: IndexPath) {
        guard
            let url = dataManager.getLocalURLForDocument(withIndex: indexPath.row),
            let sourceView = tableView.cellForRow(at: indexPath)
            else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = sourceView
        }
        present(activityVC, animated: true)
    }
    
    @IBAction func sortAction(_ sender: Any) {
        let sortMethodsVC = UIViewController.initFromStoryboard(id: StoryboardID.SortMethodsVC) as! SortMethodsViewController
        sortMethodsVC.modalPresentationStyle = .popover
        sortMethodsVC.dataManager = dataManager
        
        let popOverVC = sortMethodsVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.barButtonItem = sender as? UIBarButtonItem
        
        present(sortMethodsVC, animated: true)
    }
}

extension MainViewController: DataManagerDelegate {
    
    func updateContent() {
        tableView.reloadData()
    }
    
    func updateContent(for index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showDownloadProgress(_ value: Float, for index: Int) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MainDocumentCell {
            cell.setDownloadProgress(value)
        }
    }
    
    func reportError(with description: String) {
        showErrorAlert(with: description)
    }
}

extension MainViewController: DocumentCellDelegate {
    
    func downloadStarted(_ cell: MainDocumentCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.startDownloadingDocument(withIndex: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func donloadCancelled(_ cell: MainDocumentCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.cancelDownloadingDocument(withIndex: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let localURL = dataManager.getLocalURLForDocument(withIndex: indexPath.row) else {return}
        documentInteractionController.url = localURL
        if !documentInteractionController.presentPreview(animated: true) {
            showActivityVC(forCellAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: "\(indexPath.row)" as NSString, previewProvider: nil) { _ in
            
            let isDocumentDownloaded = self.dataManager.getDocument(withIndex: indexPath.row).downloadState == .downloaded
            var actions =  [UIAction]()
            
            if isDocumentDownloaded {
                actions.append(UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.showActivityVC(forCellAt: indexPath)
                })
            }
            actions.append(UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { _ in
                self.showRenameDialog(forCellatRow: indexPath.row)
            })
            if isDocumentDownloaded {
                actions.append(UIAction(title: "Remove from storage", image: UIImage(systemName: "xmark")) { _ in
                    self.dataManager.removeFromStorageDocument(withIndex: indexPath.row)
                    DispatchQueue.main.async { tableView.reloadData() }
                })
            }
            actions.append(UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) {_ in
                self.showDeleteDialog(forCellatRow: indexPath.row)
            })
            return UIMenu(title: "", image: nil, children: actions)
        }
    }
}

extension MainViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
