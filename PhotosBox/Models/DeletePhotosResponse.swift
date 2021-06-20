//
//  DeletePhotosResponse.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 20/06/2021.
//

import Foundation

struct DeletePhotosResponse: Codable {
    let status: Int
    let data: [PhotoInfo]
    let message: String?
    let total: Int?
}

