//
//  UIView + Ext.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 09/10/24.
//

import UIKit

extension UIView{
    
    func pinToEdges(of superView: UIView){
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }
}
