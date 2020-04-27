//
//  FileService.swift
//  VK Files
//
//  Created by Дмитрий on 25.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

class FileService {
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func localFilePath(for document: VkDocument) -> URL {
        return localFilePath(for: document.title)
    }
    
    private func localFilePath(for fileName: String) -> URL {
        documentsPath.appendingPathComponent(fileName)
    }
    
    func copyToDocuments(from location: URL, document: VkDocument) {
        var destinationURL = localFilePath(for: document)
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try destinationURL.setResourceValues(resourceValues)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isDownloaded(document: VkDocument) -> Bool {
        let filePath = localFilePath(for: document)
        return fileManager.fileExists(atPath: filePath.path)
    }
    
    func ensureDownloaded(document: VkDocument) {
        if isDownloaded(document: document) {
            document.downloadState = .downloaded
        }
    }
    
    func renameDocument(_ document: VkDocument, newName: String) {
        let filePath = localFilePath(for: document)
        do {
            try fileManager.moveItem(at: filePath, to: localFilePath(for: newName))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeDocument(_ document: VkDocument) {
        let filePath = localFilePath(for: document)
        do {
            try fileManager.removeItem(at: filePath)
            document.downloadState = .notDownloaded
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeAlldocuments() {
        do {
            for file in try fileManager.contentsOfDirectory(atPath: documentsPath.path) {
                try fileManager.removeItem(at: localFilePath(for: file))
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
