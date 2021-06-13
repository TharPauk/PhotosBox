//
//  PasscodeService.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 13/06/2021.
//

import Foundation
import KeychainSwift


class PasscodeService {
    
    static let shared = PasscodeService()
    private let keychain = KeychainSwift()
    private let defaults = UserDefaults.standard
    
    private enum Keys: String {
        case isPasscodeOn, passcode, isFirstTimeRun
    }
    
    var isFirstTimeRun: Bool {
        get {
            return defaults.bool(forKey: Keys.isFirstTimeRun.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.isFirstTimeRun.rawValue)
        }
    }
    
    private(set) var passcode: String? {
        get {
            return keychain.get(Keys.passcode.rawValue)
        }
        set {
            guard let newValue = newValue else {
                
            keychain.delete(Keys.passcode.rawValue)
                return }
            keychain.set(newValue, forKey: Keys.passcode.rawValue)
        }
    }
    
    var isPasscodeOn: Bool {
        return passcode != nil
    }
    
    @discardableResult func savePasscode(_ passcode: String?) -> String? {
        self.passcode = passcode
        return self.passcode
    }
}
