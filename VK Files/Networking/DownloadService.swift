//
//  DownloadService.swift
//  VK Files
//
//  Created by Дмитрий on 25.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

class DownloadService {
    
    
    let downloadsSession: URLSession
    
    var activeDownloads: [URL: Download] = [:]
    
    init(sessionDelegate: URLSessionDelegate) {
        downloadsSession = URLSession(configuration: URLSessionConfiguration.default, delegate: sessionDelegate,delegateQueue: nil)
    }
    
    func startDownload(_ document: VkDocument, with tableIndex: Int) {
        let download = Download(document: document, tableIndex: tableIndex)
        download.task = downloadsSession.downloadTask(with: document.url)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[document.url] = download
        document.downloadState = .downloading
    }
    
    func cancelDownload(_ document: VkDocument) {
        if let download = activeDownloads[document.url] {
            download.task?.cancel()
            activeDownloads[document.url] = nil
            document.downloadState = .notDownloaded
        }
    }
}
