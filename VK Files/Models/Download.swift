//
//  Download.swift
//  VK Files
//
//  Created by Дмитрий on 25.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

enum DownloadState {
    case notDownloaded
    case downloading
    case downloaded
}

class Download {
    var isDownloading = false
    var progress: Float = 0
    var task: URLSessionDownloadTask?
    var document: VkDocument
    var tableIndex: Int
    
    init(document: VkDocument, tableIndex: Int) {
        self.document = document
        self.tableIndex = tableIndex
    }
}
