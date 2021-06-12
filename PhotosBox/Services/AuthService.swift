//
//  AuthService.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import Foundation
import KeychainSwift

enum Keys: String {
    case token, isLoggedIn, userId, username
}

class AuthService : NSObject {
    
    static let shared = AuthService()
    private let keychain = KeychainSwift()
    private let defaults = UserDefaults.standard
    
    private(set) var userId: String? {
        get {
            return defaults.string(forKey: Keys.userId.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.userId.rawValue)
        }
    }
    
    private(set) var username: String? {
        get {
            return defaults.string(forKey: Keys.username.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.username.rawValue)
        }
    }
    
    private(set) var token: String? {
        get {
            return keychain.get(Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            keychain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private(set) var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: Keys.isLoggedIn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.isLoggedIn.rawValue)
        }
    }
    
    func setLoginUser(_ user: User) {
        self.userId = user._id
        self.username = user.name
        self.token = user.token
        self.isLoggedIn = true
    }
    
    func removeLoginUser() {
        self.userId = nil
        self.username = nil
        self.token = nil
        self.isLoggedIn = false
    }
}
