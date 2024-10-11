//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 02/10/24.
//

import UIKit
import SafariServices



extension UIViewController{
    
    
//    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
//        
//        DispatchQueue.main.async {
//            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
//            alertVC.modalPresentationStyle = .overFullScreen
//            alertVC.modalTransitionStyle = .crossDissolve
//            
//            self.present(alertVC, animated: true)
//        }
//
//        
//    }
    
    
    func presentGFAlert(title: String, message: String, buttonTitle: String){
        
        let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        
        present(alertVC, animated: true)
        
    }
    
    func presentDefaultError(){
        
        let alertVC = GFAlertVC(title: "Something went wrong", message: "we are unable to complete your task at this time.Please try again later", buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        
        present(alertVC, animated: true)
        
    }
    
    
    func presentSafariVC(with url: URL){
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
