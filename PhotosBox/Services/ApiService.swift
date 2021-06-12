//
//  ApiService.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    enum Endpoints {
        static let baseUrl = "http://192.168.100.4:4000"
        
        case signup
        case login
        
        var stringValue: String {
            switch self {
            case .signup: return "\(Endpoints.baseUrl)/users/signup"
            case .login: return "\(Endpoints.baseUrl)/users/login"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    class func signup(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    
}
