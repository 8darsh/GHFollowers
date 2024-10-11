//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 05/10/24.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    let bioLabel = GFBodyLabel(textAlignment: .left)
    let outerHorizontalStackView = UIStackView()
    let innerVericalStackView = UIStackView()
    let innerHorizontalStackView = UIStackView()
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutUI()
        configureUIElements()

        
    }
    
    func addSubviews(){
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
        view.addSubview(outerHorizontalStackView)
//        outerHorizontalStackView.addArrangedSubview(avatarImageView)
//        outerHorizontalStackView.addArrangedSubview(innerVericalStackView)
//        
//        innerVericalStackView.addArrangedSubview(usernameLabel)
//        innerVericalStackView.addArrangedSubview(nameLabel)
//        innerVericalStackView.addArrangedSubview(innerHorizontalStackView)
//        
//        innerHorizontalStackView.addArrangedSubview(locationImageView)
//        innerHorizontalStackView.addArrangedSubview(locationLabel)
//        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func configureUIElements(){
        avatarImageView.downloadAvatarImage(fromUrl: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationLabel.text = user.location ?? "Masti Mein"
        bioLabel.text = user.bio ?? "😃👍"
        bioLabel.numberOfLines = 0
    }
    

    
    
    func layoutUI(){
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        


        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90),
        
        ])
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        outerHorizontalStackView.axis = .horizontal
//        outerHorizontalStackView.spacing = textImagePadding
////        outerHorizontalStackView.distribution = .fill
//        outerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        innerVericalStackView.axis = .vertical
//        innerVericalStackView.spacing = 5
//        innerVericalStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        innerHorizontalStackView.axis = .horizontal
//        innerHorizontalStackView.spacing = 5
//        innerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        NSLayoutConstraint.activate([
//            avatarImageView.widthAnchor.constraint(equalToConstant: 100),  // Width of avatar
//              avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),  // Height equal to width (square shape)
//            
//            outerHorizontalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            outerHorizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2*padding),
//            outerHorizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            outerHorizontalStackView.heightAnchor.constraint(equalToConstant: 100),
//            
//            locationImageView.widthAnchor.constraint(equalToConstant: 30),
//            locationImageView.heightAnchor.constraint(equalToConstant: 20)
//            
//            
//        ])
    }

}
