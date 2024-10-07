//
//  ErrorMessages.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 03/10/24.
//

import Foundation

// MARK: - Before swift 5


//enum GFError: String{
//    case invalidUsername = "This username created invalid request. Please try again"
//    case unableToCompleteRequest = "Unable to complete your request. Please check your Internet."
//    case invalidResponse = "Invalid Response from the server. Try again later."
//    
//    case invalidData = "The data recieved from the server was invalid. Please try again"
//}


// MARK: - After swift 5 when Result is introduced


enum GFError: String, Error{
    case invalidUsername = "This username created invalid request. Please try again"
    case unableToCompleteRequest = "Unable to complete your request. Please check your Internet."
    case invalidResponse = "Invalid Response from the server. Try again later."
    
    case invalidData = "The data recieved from the server was invalid. Please try again"
    case unableToFavorite = "Unable to favorite the user. Please try again later."
    case alreadyInFavorites = "User is already in favorites."
}
