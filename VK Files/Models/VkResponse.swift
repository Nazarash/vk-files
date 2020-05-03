//
//  VkDocsGetResponse.swift
//  VK Files
//
//  Created by Дмитрий on 24.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation

typealias VkResponseCode = Int

struct VkDocsGetWrappedResponse: Codable {
    let response: VKDocsGetResponse
}

struct VKDocsGetResponse: Codable {
    let count: Int
    let items: [VkDocument]
}

struct VkDocPreview: Codable {
    let photo: VkDocPhotoPreview?
}

struct VkDocPhotoPreview: Codable {
    let sizes: [VkPreviewSize]
}

struct VkPreviewSize: Codable {
    let src: URL
    let type: String
}

struct VkUsersGetResponse: Codable {
    let response: [User]
}

struct VkErrorResponse: Codable {
    let error: VkError
}

struct VkError: Codable {
    let errorCode: Int
    let errorMsg: String
}

struct VkActionResponse: Codable {
    let response: VkResponseCode
}
