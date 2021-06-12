//
//  ApiService.swift
//  PhotosBox
//
//  Created by Min Thet Maung on 12/06/2021.
//

import Foundation
import Alamofire

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
    
    func signup(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let body = ["name": name, "email": email, "password": password]
        AF.request(Endpoints.signup.url, method: .post, parameters: body).responseJSON { (response) in
            
            guard let data = response.data else { return }
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                guard let token = result.data?.token else {
                    completion(false, result.message)
                    return
                }
                print("token: \(token)")
                
                completion(true, result.message)
            } catch (let err) {
                completion(false, err.localizedDescription)
            }
        }
    }
    
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let body = ["email": email, "password": password]
        AF.request(Endpoints.login.url, method: .post, parameters: body).responseJSON { (response) in
            
            guard let data = response.data else { return }
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                guard let token = result.data?.token else {
                    completion(false, result.message)
                    return
                }
                print("token: \(token)")
                
                completion(true, result.message)
            } catch (let err) {
                completion(false, err.localizedDescription)
            }
        }
    }
    
    
    
}
