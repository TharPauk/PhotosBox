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
        case upload
        
        var stringValue: String {
            switch self {
            case .signup: return "\(Endpoints.baseUrl)/users/signup"
            case .login: return "\(Endpoints.baseUrl)/users/login"
            case .upload: return "\(Endpoints.baseUrl)/posts/"
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
                guard let user = result.data else {
                    completion(false, result.message)
                    return
                }
                
                AuthService.shared.setLoginUser(user)
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
                guard let user = result.data else {
                    completion(false, result.message)
                    return
                }
                
                AuthService.shared.setLoginUser(user)
                completion(true, result.message)
            } catch (let err) {
                completion(false, err.localizedDescription)
            }
        }
    }
    
    
    func upload(images: [Data], progressUpdate: @escaping (Progress) -> Void, completion: @escaping (Bool, String?) -> Void) {
        guard let token = AuthService.shared.token else { return }
        
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded"), HTTPHeader(name: "Authorization", value: token))
    
      
        AF.upload(multipartFormData: { (formData) in
            
            images.forEach {
                formData.append($0, withName: "images", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }
            
        }, to: Endpoints.upload.url, method: .post, headers: headers)
        .responseJSON(completionHandler: { (resp) in
            if let err = resp.error {
                fatalError("Error in creating post reponse : \(err.localizedDescription)")
            }
            print("status = \(resp.response?.statusCode)")
            completion(true, nil)
        }).uploadProgress(closure: progressUpdate)
        
    }
    
    
    
}
