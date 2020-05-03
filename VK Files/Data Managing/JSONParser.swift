//
//  JSONParser.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

class JSONParser {
    
    let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func parseDocuments(_ data: Data) -> Result<[VkDocument], NetworkError> {
        if let wrappedResponse = try? decoder.decode(VkDocsGetWrappedResponse.self, from: data) {
            return .success(wrappedResponse.response.items)
        } else {
            return .failure(parseError(data))
        }
    }
    
    func parseUser(_ data: Data) -> Result<User, NetworkError> {
        if let response = try? decoder.decode(VkUsersGetResponse.self, from: data) {
            if response.response.count == 1 {
                return .success(response.response[0])
            } else {
                return .failure(NetworkError.unknownError)
            }
        } else {
            return .failure(parseError(data))
        }
    }
    
    func parseAction(_ data: Data) -> Result<Int, NetworkError> {
        if let response = try? decoder.decode(VkActionResponse.self, from: data) {
            return .success(response.response)
        } else {
            return .failure(parseError(data))
        }
    }
    
    func parseError(_ data: Data) -> NetworkError {
        if let errorResponse = try? decoder.decode(VkErrorResponse.self, from: data) {
            print("VK error: \(errorResponse.error.errorMsg)\n")
            return NetworkError.vkError
        } else {
            return NetworkError.parsingError
        }
    }
    
}


