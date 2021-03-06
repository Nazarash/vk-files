//
//  SortMethods.swift
//  VK Files
//
//  Created by Дмитрий on 29.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

typealias ComparingMethod = (VkDocument, VkDocument) -> Bool

enum SortMethods: String, CaseIterable {
    case titleAscending = "Name A→Z"
    case titleDescending = "Name Z→A"
    case dateAscending = "Date 0→9"
    case dateDescending = "Date 9→0"
    case sizeAscending = "Size 0→9"
    case sizeDescending = "Size 9→0"
    case typeAscending = "Type A→Z"
    case typeDescending = "Type Z→A"
    
    
    var method: ComparingMethod {
        switch self {
        case .titleAscending:
            return { $0.title.lowercased() < $1.title.lowercased() }
        case .titleDescending:
            return { $0.title.lowercased() > $1.title.lowercased() }
        case .dateAscending:
            return { $0.creationDate < $1.creationDate }
        case .dateDescending:
            return { $0.creationDate > $1.creationDate }
        case .sizeAscending:
            return { $0.size < $1.size }
        case .sizeDescending:
            return { $0.size > $1.size }
        case .typeAscending:
            return { $0.ext < $1.ext }
        case .typeDescending:
            return { $0.ext > $1.ext }
        }
    }
    
    var descriptor: NSSortDescriptor {
        switch self {
        case .titleAscending:
            return NSSortDescriptor(key: "title", ascending: true)
        case .titleDescending:
            return NSSortDescriptor(key: "title", ascending: false)
        case .dateAscending:
            return NSSortDescriptor(key: "creationDate", ascending: true)
        case .dateDescending:
            return NSSortDescriptor(key: "creationDate", ascending: false)
        case .sizeAscending:
            return NSSortDescriptor(key: "size", ascending: true)
        case .sizeDescending:
            return NSSortDescriptor(key: "size", ascending: false)
        case .typeAscending:
            return NSSortDescriptor(key: "type", ascending: true)
        case .typeDescending:
            return NSSortDescriptor(key: "type", ascending: false)
        }
    }
    
    
}
