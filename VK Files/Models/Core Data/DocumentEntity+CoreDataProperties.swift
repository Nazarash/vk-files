//
//  DocumentEntity+CoreDataProperties.swift
//  VK Files
//
//  Created by Дмитрий on 01.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//
//

import Foundation
import CoreData


extension DocumentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentEntity> {
        return NSFetchRequest<DocumentEntity>(entityName: "DocumentEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var size: Int64
    @NSManaged public var ext: String
    @NSManaged public var url: URL
    @NSManaged public var creationDate: Date
    @NSManaged public var type: Int16
    @NSManaged public var preview: URL?

}
