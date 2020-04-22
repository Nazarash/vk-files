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

struct VkDocument {
    
    let id: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let creationDate: Date
    let type: DocType
    
    var systemImageName: String {
        switch type {
        case .textDoc:
            return "doc.text.fill"
        case .archive:
            return "archivebox.fill"
        case .gif:
            return "play.rectangle.fill"
        case .image:
            return "photo.fill"
        case .audio:
            return "music.note"
        case .video:
            return "film.fill"
        case .book:
            return "book.fill"
        default:
            return "questionmark.square.fill"
        }
    }
    
    var approximateSize: String {
        switch size {
        case 1 ..< 1<<10:
            return  "\(size) B"
        case 1<<10 ..< 1<<20:
            return  "\(size / 1<<10) KB"
        default:
            return  "\(size / 1<<20) MB"
        }
    }
    
    
    
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
