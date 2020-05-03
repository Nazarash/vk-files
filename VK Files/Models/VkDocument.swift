//
//  VkDocument.swift
//  VK Files
//
//  Created by Дмитрий on 19.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

enum DocType: Int, Codable, CaseIterable {
    case textDoc = 1
    case archive
    case gif
    case image
    case audio
    case video
    case book
    case other
    
    var systemImageName: String {
        switch self {
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
    
    var description: String {
        switch self {
        case .textDoc:
            return "Text documents"
        case .archive:
            return "Archives"
        case .gif:
            return "GIFs"
        case .image:
            return "Pictures"
        case .audio:
            return "Audio"
        case .video:
            return "Video"
        case .book:
            return "Books"
        default:
            return "Other files"
        }
    }
}

typealias DocumentID = Int

class VkDocument: Codable {
    
    let id: DocumentID
    let title: String
    let size: Int
    let ext: String
    let url: URL
    let creationDate: Date
    let type: DocType
    var rawPreviews: VkDocPreview?
    
    var downloadState = DownloadState.notDownloaded
    
    var preview: URL? {
        get {
            return rawPreviews?.photo?.sizes.filter{ $0.type == "m" }.first?.src
        }
        set {
            if let newValue = newValue {
                rawPreviews = VkDocPreview(photo: VkDocPhotoPreview(sizes: [VkPreviewSize(src: newValue, type: "m")]))
            }
        }
    }
    
    private init(id: DocumentID, title: String, size: Int, ext: String, url: URL, date: Date, type: Int, preview: URL?) {
        self.id = id
        self.title = title
        self.size = size
        self.ext = ext
        self.url = url
        self.creationDate = date
        self.type = DocType.init(rawValue: type) ?? .other
        self.preview = preview
    }
    
    convenience init(entity: DocumentEntity) {
        self.init(id: DocumentID(entity.id),
                  title: entity.title,
                  size: Int(entity.size),
                  ext: entity.ext,
                  url: entity.url,
                  date: entity.creationDate,
                  type: Int(entity.type),
                  preview: entity.preview)
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case size
        case ext
        case url
        case creationDate = "date"
        case type
        case rawPreviews = "preview"
    }
}

extension VkDocument: Hashable {
    
    static func == (lhs: VkDocument, rhs: VkDocument) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return id.hash(into: &hasher)
    }
    
}
