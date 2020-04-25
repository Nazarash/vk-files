//
//  VkDocument.swift
//  VK Files
//
//  Created by Дмитрий on 19.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

enum DocType: Int, Codable {
    case textDoc = 1
    case archive
    case gif
    case image
    case audio
    case video
    case book
    case other
}

class VkDocument: Codable {
    
    let id: Int
    let title: String
    let size: Int64
    let ext: String
    let url: URL
    let creationDate: Date
    let type: DocType
    
    var downloadState = DownloadState.notDownloaded
    
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
    
    init(id: Int, title: String, size: Int64, ext: String, url: String, date: Int, type: Int) {
        self.id = id
        self.title = title
        self.size = size
        self.ext = ext
        self.url = URL(string: url)!
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(date))
        self.type = DocType.init(rawValue: type) ?? .other
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case size
        case ext
        case url
        case creationDate = "date"
        case type
    }
}

