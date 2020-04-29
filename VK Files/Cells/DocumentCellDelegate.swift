//
//  DocumentCellDelegate.swift
//  VK Files
//
//  Created by Дмитрий on 25.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

protocol DocumentCellDelegate {
    
    func downloadStarted(_ cell: MainDocumentCell)
    
    func donloadCancelled(_ cell: MainDocumentCell)
}
