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
}

extension User: Codable {
    
    enum CodingKeys : String, CodingKey {
        case id
        case firstName
        case lastName
        case photoURL = "photo400"
    }
}
