//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 05/10/24.
//

import UIKit
protocol GFFollowerItemVCDelegate: AnyObject{
    func didTapGetFollowers(for user: User)
}
class GFFollowerItemVC: GFItemInfoVC{
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers",systemImageName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
