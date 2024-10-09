//
//  UIhelper.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 03/10/24.
//

import UIKit

enum UIHelper{
    
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout {
     
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumInteritemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumInteritemSpacing*2)
        let itemWidth = availableWidth / 3
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowlayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowlayout
    }

}
