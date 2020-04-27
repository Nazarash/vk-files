//
//  DataManager.swift
//  VK Files
//
//  Created by Дмитрий on 27.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation
import UIKit

class DataManager: NSObject {
    
    typealias DocumentID = Int
    
    private var documents = [VkDocument]()
    var indexOf = [DocumentID: Int]()
    
    private var queryService: QueryService!
    private var fileService: FileService!
    private var downloadService: DownloadService!
    
    weak var delegate: DataManagerDelegate!
    
    override init() {
        super.init()
        queryService = QueryService()
        fileService = FileService()
        downloadService = DownloadService(sessionDelegate: self)
    }
    
    func getDocument(withIndex index: Int) -> VkDocument {
        return documents[index]
    }
    
    func getLocalURLForDocument(withIndex index: Int) -> URL? {
        let document = documents[index]
        if fileService.isDownloaded(document: document) {
            return fileService.localFilePath(for: documents[index])
        } else {
            return nil
        }
    }
    
    func removeFromStorageDocument(withIndex index: Int) {
        fileService.removeDocument(documents[index])
    }
    
    func updateContent() {
        queryService.getDocuments() { result in
            switch result {
            case .success(let docs):
                self.documents = docs
                self.delegate.updateContent()
                self.updateDocumentIndices()
            case .failure(let error):
                self.delegate.reportError(with: error.localizedDescription)
            }
        }
    }
    
    func updateDocumentIndices() {
        indexOf.removeAll(keepingCapacity: true)
        for (index, document) in documents.enumerated() {
            indexOf[document.id] = index
        }
    }
    
    func renameDocument(withIndex index: Int, newName: String) {
        let document = documents[index]
        queryService.renameDocument(id: document.id, newName: newName) { result in
            switch result {
            case .success:
                self.fileService.renameDocument(document, newName: newName)
                self.updateContent()
                self.delegate.updateContent()
            case .failure(let error):
                self.delegate.reportError(with: error.localizedDescription)
            }
        }
    }
    
    func deleteDocument(withIndex index: Int) {
        let document = documents[index]
        queryService.deleteDocument(id: document.id) { result in
            switch result {
            case .success:
                self.fileService.removeDocument(document)
                self.updateContent()
                self.delegate.updateContent()
            case .failure(let error):
                self.delegate.reportError(with: error.localizedDescription)
            }
        }
    }
    
    func startDownloadingDocument(withIndex index: Int) {
        downloadService.startDownload(documents[index])
    }
    
    func cancelDownloadingDocument(withIndex index: Int) {
        downloadService.cancelDownload(documents[index])
    }
}

extension DataManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainDocumentCell.identifier, for: indexPath) as! MainDocumentCell
        fileService.ensureDownloaded(document: documents[indexPath.row])
        cell.delegate = delegate as? DocumentCellDelegate
        cell.configure(with: documents[indexPath.row])
        return cell
    }
}

extension DataManager: URLSessionDownloadDelegate {
    
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
            if let index = self?.indexOf[download.document.id] {
                self?.delegate.updateContent(for: index)
            }
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
            if let index = self.indexOf[download.document.id] {
                self.delegate.showDownloadProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), for: index)
            }
        }
    }
}
