//
//  User.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 21/06/2021.
//

import Foundation

struct User: Codable {
    let _id: String
    let name: String?
    let email: String
    let token: String?
}
