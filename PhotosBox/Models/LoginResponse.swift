//
//  LoginResponse.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import Foundation

struct LoginResponse: Codable {
    let status: Int
    let data: User?
    let message: String?
}

