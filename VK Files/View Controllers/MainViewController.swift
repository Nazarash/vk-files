//
//  MainViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    typealias DocumentID = Int
    
    @IBOutlet weak var tableView: UITableView!
    
    var downloadService: DownloadService!
    var queryService: QueryService!
    var fileService: FileService!
    
    var documents = [VkDocument]()
    var indexOf = [DocumentID: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.downloadService = DownloadService(sessionDelegate: self)
        self.queryService = QueryService()
        self.fileService = FileService()
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
                self.updateDocumentIndices()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    func updateDocumentIndices() {
        indexOf.removeAll(keepingCapacity: true)
        for (index, document) in documents.enumerated() {
            indexOf[document.id] = index
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
                self.fileService.removeDocument(document)
                self.updateContent()
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
}

extension MainViewController: DocumentCellDelegate {
    
    func downloadStarted(_ cell: MainDocumentCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            downloadService.startDownload(documents[indexPath.row], with: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func donloadCancelled(_ cell: MainDocumentCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            downloadService.cancelDownload(documents[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainDocumentCell.identifier, for: indexPath) as! MainDocumentCell
        fileService.checkDownloaded(document: documents[indexPath.row])
        cell.delegate = self
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
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) {_ in
                self.showDeleteDialog(for: self.documents[indexPath.row])
            }
            
            if self.documents[indexPath.row].downloadState == .downloaded {
                let removeAction = UIAction(title: "Remove from storage", image: UIImage(systemName: "xmark")) { _ in
                    self.fileService.removeDocument(self.documents[indexPath.row])
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
                return UIMenu(title: "", image: nil, children: [renameAction, removeAction, deleteAction])
            }
            return UIMenu(title: "", image: nil, children: [renameAction, deleteAction])
        }
    }
}

extension MainViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard
            let sourceURL = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[sourceURL]
        else {
            return
        }
        downloadService.activeDownloads[sourceURL] = nil
        
        fileService.copyToDocuments(from: location, document: download.document)
        download.document.downloadState = .downloaded
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: download.tableIndex, section: 0)], with: .none)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard
            let sourceURL = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[sourceURL]
        else {
            return
        }
        
        DispatchQueue.main.async {
            if let row = self.indexOf[download.document.id],
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? MainDocumentCell {
                cell.setDownloadProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
            }
        }
    }
}
