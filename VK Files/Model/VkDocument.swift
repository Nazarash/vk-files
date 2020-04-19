//
//  VkDocument.swift
//  VK Files
//
//  Created by Дмитрий on 19.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

enum DocType: Int {
    case textDoc = 1
    case archive
    case gif
    case image
    case audio
    case video
    case book
    case other
}

class VkDocument {
    
    let id: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let creationDate: Date
    let type: DocType
    
    init(_ id: Int, _ title: String, _ size: Int, _ ext: String, _ url: String, _ creationDate: Int, _ type: Int) {
        self.id = id
        self.title = title
        self.size = size
        self.ext = ext
        self.url = url
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(creationDate))
        self.type = DocType(rawValue: type) ?? .other
    }
}
