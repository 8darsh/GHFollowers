//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 03/10/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    
    
    let placeholderImage = Images.avatarplaceholder
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        
        layer.cornerRadius = 10 //it sets the imageView radius
        clipsToBounds = true //it applies the radius to action image
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    


}
