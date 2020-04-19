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
    
    private let scheme = "https"
    private let host = "api.vk.com"
    private let version = "5.103"
    private let methodPath = "/method/"
    private var commonParameters = [String: String]()
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    var documents: [VkDocument] = []
    
    init() {
        commonParameters["access_token"] = VKSdk.accessToken()?.accessToken
        commonParameters["v"] = version
    }
    
    func getDocuments(completion: @escaping ([VkDocument]?) -> Void) {
        
        dataTask?.cancel()
        let url = buildUrl(for: "docs.get")
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                self?.parseJson(data)
                DispatchQueue.main.async {
                    completion(self?.documents)
                }
            }
        }
        dataTask?.resume()
    }
    
    private func parseJson(_ data: Data) {
        documents.removeAll()
        
        if let json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]){
            let response = json["response"] as! [String: Any]
            let items = response["items"]! as! [[String: Any]]
            for item in items {
                let id = item["id"] as! Int
                let title = item["title"] as! String
                let size = item["size"] as! Int
                let ext = item["ext"] as! String
                let url = item["url"] as! String
                let date = item["date"] as! Int
                let type = item["type"] as! Int
                documents.append(VkDocument(id, title, size, ext, url, date, type))
            }
        }
        
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
