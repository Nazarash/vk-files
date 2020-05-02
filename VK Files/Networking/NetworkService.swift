//
//  NetworkService.swift
//  VK Files
//
//  Created by Дмитрий on 02.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

class NetworkService {
    
    enum NetworkState {
        case online
        case offline
    }
    
    static var state: NetworkState = .online
    
    
}
