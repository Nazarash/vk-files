//
//  NetworkError.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case queryError
    case vkError
    case parsingError
    case unknownError
    
    var localizedDescription: String? {
        switch self {
        case .queryError:
            return "Error while connecting to server"
        case .vkError:
            return "Error on VK server"
        case .parsingError:
            return "Error while parsing data"
        default:
            return "Something went wrong"
        }
    }
    
}
