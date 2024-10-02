//
//  ValidationEmailPassword.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 02/10/24.
//

import Foundation

extension String{
    
    var isValidEmail: Bool{
        let emailFormat = "^[a-zA-Z0-9_.±]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool{
        let passwordFormat = ""
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
}
