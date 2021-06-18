//
//  FetchPostsResponse.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 17/06/2021.
//

import Foundation

struct FetchPostsResponse: Codable {
    let status: Int
    let data: [PhotoInfo]
    let message: String?
    let total: Int?
}

struct PhotoInfo: Codable {
    let _id: String
    let imageName: String
    let createdAt: String
    let imageUrl: String
    let timeAgo: String
}
