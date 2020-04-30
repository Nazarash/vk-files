//
//  UIImageView.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(from imageURL: URL?) {
        guard let url = imageURL else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.transition(toImage: UIImage(data: imageData))
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                guard
                    let data = data,
                    let response = response
                    else { return }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                DispatchQueue.main.async {
                    self.transition(toImage: UIImage(data: data))
                }
            }.resume()
        }
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: { self.image = image },
                          completion: nil)
    }
}
