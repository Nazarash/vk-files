//
//  VkUser.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

struct User {
    
    let id: Int
    let firstName: String
    let lastName: String
    let photoURL: URL
    
    init(entity: UserEntity) {
        self.id = Int(entity.id)
        self.firstName = entity.firstName
        self.lastName = entity.lastName
        self.photoURL = entity.photoURL
    }
}

extension User: Codable {
    
    enum CodingKeys : String, CodingKey {
        case id
        case firstName
        case lastName
        case photoURL = "photo400"
    }
}
