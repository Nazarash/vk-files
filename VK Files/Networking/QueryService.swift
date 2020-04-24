//
//  ApiManager.swift
//  VK Files
//
//  Created by Дмитрий on 18.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation
import VKSdkFramework

class QueryService {
    
    typealias Completion<T> = (Result<T, NetworkError>) -> Void
    
    private let scheme = "https"
    private let host = "api.vk.com"
    private let version = "5.103"
    private let methodPath = "/method/"
    private var commonParameters = [String: String]()
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private let parser: JSONParser
    
    
    init() {
        commonParameters["access_token"] = VKSdk.accessToken()?.accessToken
        commonParameters["v"] = version
        
        parser = JSONParser()
    }
    
    func getDocuments(completion: @escaping Completion<[VkDocument]>) {
        let url = buildUrl(for: "docs.get")
        makeRequest(path: url, type: [VkDocument].self, completion: completion)
    }
    
    func getUser(completion: @escaping Completion<User>) {
        let parameters = ["fields": "photo_200"]
        let url = buildUrl(for: "users.get", parameters: parameters)
        makeRequest(path: url, type: User.self, completion: completion)
    }
    
    func deleteDocument(id: Int, completion: @escaping Completion<Int>) {
        self.getUser() { result in
            switch result {
            case .success(let user):
                let parameters = ["doc_id": "\(id)", "owner_id": "\(user.id)"]
                let url = self.buildUrl(for: "docs.delete", parameters: parameters)
                self.makeRequest(path: url, type: Int.self, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func renameDocument(id: Int, newName: String, completion: @escaping Completion<Int>) {
        let parameters = ["doc_id": "\(id)", "title": newName]
        let url = buildUrl(for: "docs.edit", parameters: parameters)
        makeRequest(path: url, type: Int.self, completion: completion)
    }
    
    func makeRequest<T>(path: URL, type: T.Type, completion: @escaping Completion<T>) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: path) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.queryError))
                }
            } else if let data = data {
                DispatchQueue.main.async {
                    switch type {
                    case is [VkDocument].Type:
                        completion(self!.parser.parseDocuments(data) as! Result<T, NetworkError>)
                    case is User.Type:
                        completion(self!.parser.parseUser(data) as! Result<T, NetworkError>)
                    case is Int.Type:
                        completion(self!.parser.parseAction(data) as! Result<T, NetworkError>)
                    default:
                        completion(.failure(NetworkError.unknownError))
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    private func buildUrl(for methodName: String, parameters: [String: String] = [:]) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = methodPath + methodName
        let allParameters = commonParameters.merging(parameters) {(_, new) in new}
        components.queryItems = allParameters.map() {URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
}
