//
//  DataPresenterDelegate.swift
//  VK Files
//
//  Created by Дмитрий on 27.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

protocol DataManagerDelegate: AnyObject {
    
    func updateContent()
    
    func updateContent(for index: Int)
    
    func showDownloadProgress(_ value: Float, for index: Int)
    
    func reportError(with description: String)
}
