//
//  UserEntity+CoreDataClass.swift
//  VK Files
//
//  Created by Дмитрий on 01.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {

    func initialize(with user: User) {
        self.id = Int32(user.id)
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.photoURL = user.photoURL
    }
}
