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
        static let baseUrl = "https://photosbox.herokuapp.com"
        
        case signup, login, upload, fetchPhotos, deletePhotos
        
        var stringValue: String {
            switch self {
            case .signup: return "\(Endpoints.baseUrl)/users/signup"
            case .login: return "\(Endpoints.baseUrl)/users/login"
            case .upload: return "\(Endpoints.baseUrl)/posts/"
            case .fetchPhotos: return "\(Endpoints.baseUrl)/posts/"
            case .deletePhotos: return "\(Endpoints.baseUrl)/posts/remove"
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
                completion(false, err.localizedDescription)
            }
            completion(true, nil)
        }).uploadProgress(closure: progressUpdate)
        
    }
    
    func getPhotos(completion: @escaping (Bool, [PhotoInfo]) -> Void) {
        guard let token = AuthService.shared.token else { return }
        
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded"), HTTPHeader(name: "Authorization", value: token))
    
        AF.request(Endpoints.fetchPhotos.url, method: .get, headers: headers).responseJSON { (resp) in
            if let err = resp.error {
                print("Error in fetching post reponse : \(err.localizedDescription)")
                completion(false, [])
            }
            
            guard let data = resp.data else { return }
            do {
                let result = try JSONDecoder().decode(FetchPhotosResponse.self, from: data)
                completion(true, result.data)
            } catch {
                completion(false, [])
            }
        }
    }
    
    
    
    func deletePhotos(photosIds: [String], completion: @escaping (Bool, [PhotoInfo]) -> Void) {
        guard let token = AuthService.shared.token else { return }
        
        let body = ["photos": photosIds]
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded"), HTTPHeader(name: "Authorization", value: token))
        AF.request(Endpoints.deletePhotos.url, method: .post, parameters: body, headers: headers).responseJSON { (resp) in
            if let err = resp.error {
                print("Error in deleting post reponse : \(err.localizedDescription)")
                completion(false, [])
            }
            
            guard let data = resp.data else { return }
            do {
                let result = try JSONDecoder().decode(DeletePhotosResponse.self, from: data)
                completion(true, result.data)
            } catch {
                print("Decoding error")
                completion(false, [])
            }
        }
    }
    
}
