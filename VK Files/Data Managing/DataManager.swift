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
    
    private var rawDocuments = [VkDocument]()
    private var filteredDocuments = [VkDocument]()
    private var filterApplied = false
    private var isUpdating = false
    
    private var documents: [VkDocument] {
        return filterApplied ? filteredDocuments : rawDocuments
    }
    private var indexOf = [VkDocument: Int]()
    private var sortMethod: SortMethods!
    
    private var queryService =  QueryService()
    private var fileService =  FileService()
    private var downloadService: DownloadService!
    private var coreDataManager = CoreDataManager.shared
    
    weak var delegate: DataManagerDelegate!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        downloadService = DownloadService(sessionDelegate: self)
        
        let savedMethod = UserDefaults.standard.string(forKey: "sortMethod")
        sortMethod = SortMethods.init(rawValue: savedMethod ?? SortMethods.dateDescending.rawValue)
        
        rawDocuments = coreDataManager.getDocuments(using: sortMethod)
        self.updateDocumentIndices()
    }
    
    // MARK: - Actions with data
    
    func getDocument(withIndex index: Int) -> VkDocument {
        return documents[index]
    }
    
    func hasData() -> Bool {
        return !documents.isEmpty
    }
    
    func getLocalURLForDocument(withIndex index: Int) -> URL? {
        let document = documents[index]
        if fileService.isDownloaded(document: document) {
            return fileService.localFilePath(for: documents[index])
        } else {
            return nil
        }
    }
    
    func updateData() {
        if isUpdating || !downloadService.activeDownloads.isEmpty { return }
        isUpdating = true
        queryService.getDocuments() { result in
            switch result {
            case .success(let docs):
                NetworkService.state = .online
                self.rawDocuments = docs
                if self.sortMethod != .dateDescending {
                    self.sortData()
                }
                self.updateDocumentIndices()
                DispatchQueue.global(qos: .background).async {
                    self.coreDataManager.sync(withLoaded: docs)
                }
            case .failure(let error):
                if NetworkService.state == .online {
                    self.delegate.reportError(with: error.localizedDescription)
                    NetworkService.state = .offline
                }
            }
            self.delegate.updateContent()
            self.isUpdating = false
        }
    }
    
    func updateDocumentIndices() {
        var newIndices = [VkDocument: Int]()
        for (index, document) in documents.enumerated() {
            newIndices[document] = index
        }
        indexOf = newIndices
    }
    
    func sortData() {
        rawDocuments.sort(by: sortMethod.method)
        filteredDocuments.sort(by: sortMethod.method)
    }
    
    // MARK: - Actions with documents
    
    func renameDocument(withIndex index: Int, newName: String) {
        let document = documents[index]
        queryService.renameDocument(id: document.id, newName: newName) { result in
            switch result {
            case .success:
                self.fileService.renameDocument(document, newName: newName)
                self.coreDataManager.renameDocument(document)
                self.updateData()
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
                self.coreDataManager.deleteDocument(document)
                self.updateData()
            case .failure(let error):
                self.delegate.reportError(with: error.localizedDescription)
            }
        }
    }
    
    func removeFromStorageDocument(withIndex index: Int) {
        fileService.removeDocument(documents[index])
    }
    
    func startDownloadingDocument(withIndex index: Int) {
        downloadService.startDownload(documents[index])
    }
    
    func cancelDownloadingDocument(withIndex index: Int) {
        downloadService.cancelDownload(documents[index])
    }
    
    // MARK: - Actions with displayed data
    
    func applySortMethod(_ sortMethod: SortMethods) {
        self.sortMethod = sortMethod
        UserDefaults.standard.set(sortMethod.rawValue, forKey: "sortMethod")
        sortData()
        updateDocumentIndices()
        delegate.updateContent()
    }
    
    func applyFilterWithSearch(text: String) {
        if text.count == 0 {
            filterApplied = false
        } else {
            filteredDocuments = rawDocuments.filter{ $0.title.lowercased().contains(text.lowercased()) }
            filterApplied = true
        }
        updateDocumentIndices()
        delegate.updateContent()
    }
    
    func applyFilterWithType(type: DocType?) {
        if let type = type {
            filteredDocuments = rawDocuments.filter { $0.type == type }
            filterApplied = true
        } else {
            filterApplied = false
        }
        updateDocumentIndices()
        delegate.updateContent()
    }
}

// MARK: - Implementing delegates

extension DataManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier, for: indexPath) as! DocumentCell
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
            if let index = self?.indexOf[download.document] {
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
            if let index = self.indexOf[download.document] {
                self.delegate.showDownloadProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), for: index)
            }
        }
    }
}
