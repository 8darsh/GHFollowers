//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 07/10/24.
//

import Foundation

enum PersistenceActionType{
    case add, remove
}

enum PersistenceManager{
   
    static private let defaults = UserDefaults.standard
    
    enum Keys{
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping(GFError?) -> Void){
        
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFav = favorites
                
                switch actionType {
                case .add:
                    guard !retrievedFav.contains(favorite) else{
                        completed(.alreadyInFavorites)
                        return
                    }
                    retrievedFav.append(favorite)
                case .remove:
                    retrievedFav.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: retrievedFav))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping(Result<[Follower],GFError>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else{
            completed(.success([]))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(followers))
        }
        catch{
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError?{
        
        do{
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        }
        catch{
            return .unableToFavorite
        }
        
        
    }
}
