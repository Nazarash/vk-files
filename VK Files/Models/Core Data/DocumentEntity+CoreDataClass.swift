//
//  DocumentEntity+CoreDataClass.swift
//  VK Files
//
//  Created by Дмитрий on 01.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DocumentEntity)
public class DocumentEntity: NSManagedObject {

    func initialize(with document: VkDocument) {
        self.id = Int64(document.id)
        self.title = document.title
        self.size = Int64(document.size)
        self.ext = document.ext
        self.url = document.url
        self.creationDate = document.creationDate
        self.type = Int16(document.type.rawValue)
        self.preview = document.preview
    }
}
