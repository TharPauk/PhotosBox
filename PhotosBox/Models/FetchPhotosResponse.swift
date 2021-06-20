//
//  FetchPostsResponse.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 17/06/2021.
//

import Foundation

struct FetchPhotosResponse: Codable {
    let status: Int
    let data: [PhotoInfo]
    let message: String?
    let total: Int?
}
