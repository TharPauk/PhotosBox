//
//  PhotoInfo.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 20/06/2021.
//

import Foundation

struct PhotoInfo: Codable {
    let _id: String
    let user: String?
    let imageName: String?
    let createdAt: String?
    let updatedAt: String?
    let imageUrl: String
    let timeAgo: String?
}
