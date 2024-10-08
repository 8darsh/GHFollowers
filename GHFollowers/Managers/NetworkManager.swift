//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 03/10/24.
//

import UIKit

class NetworkManager{
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    

    // MARK: - After Swift 5 Result
    

    func getFollowers(for user: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void){
        let endpoint = baseUrl + user + "/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data,response,error in
            
            if error != nil{
                completed(.failure(.unableToCompleteRequest))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data else{
                completed(.failure(.invalidData))
                return
            }
            
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            }catch{
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getUserInfo(for user: String, completed: @escaping(Result<User, GFError>) -> Void){
        
        let endPoint = baseUrl + user
        guard let url = URL(string: endPoint) else{
            completed(.failure(.invalidUsername))
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil{
                completed(.failure(.unableToCompleteRequest))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                
                return
            }
            
            guard let data else {
                completed(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
                
            }catch{
                completed(.failure(.invalidData))
            }
        }
        dataTask.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?)->Void){
        
        //Cacheing the data
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        
        //If image is not downloaded below code will run
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data=data,
                  let image = UIImage(data: data) else{
                completed(nil)
                return
            }
            
            
            self.cache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        
        task.resume()
    }
}









// MARK: - Before Swift 5


//    func getFollowers(for user: String, page: Int, completed: @escaping([Follower]?, ErrorMessages?) -> Void){
//        let endpoint = baseUrl + user + "/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(nil, .invalidUsername)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) {data,response,error in
//
//            if error != nil{
//                completed(nil, .unableToCompleteRequest)
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(nil, .invalidResponse)
//                return
//            }
//
//            guard let data else{
//                completed(nil, .invalidData)
//                return
//            }
//
//
//            do{
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                completed(followers, nil)
//            }catch{
//                completed(nil,.invalidData)
//            }
//        }
//        task.resume()
//
//
//
//    }

