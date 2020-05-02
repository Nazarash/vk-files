//
//  UserEntity+CoreDataProperties.swift
//  VK Files
//
//  Created by Дмитрий on 01.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var photoURL: URL

}
