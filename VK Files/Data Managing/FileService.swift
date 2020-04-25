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
        return documentsPath.appendingPathComponent(document.title)
    }
    
    func copyToDocuments(from location: URL, document: VkDocument) {
        let destinationURL = localFilePath(for: document)
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func checkDownloaded(document: VkDocument) {
        let fileManager = FileManager.default
        let filePath = localFilePath(for: document)
        if fileManager.fileExists(atPath: filePath.path) {
            document.downloadState = .downloaded
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
            for path in try fileManager.contentsOfDirectory(atPath: documentsPath.path) {
                try fileManager.removeItem(atPath: path)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
