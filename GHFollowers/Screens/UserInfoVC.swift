//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 05/10/24.
//

import UIKit
import SafariServices
protocol UserInfoVCDelegate: AnyObject{
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: GFDataLoadingVC {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews:[UIView] = []
    
    var username: String!
    var dateLabel = GFBodyLabel(textAlignment: .center)
    
    weak var delegate: FollowerListVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureUI()
        getUser(username: username)
        
    }
    
    
    func configureVC(){
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    func getUser(username: String){
       
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async{
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Unable to show user", message: error.rawValue, buttonTitle: "Ok")
//                self.dismiss(animated: true)
            }
        }
       
    }
    
    func configureUIElements(with user: User){

        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "Github Since \(user.createdAt.convertToMonthYear())"
    }
    
    func configureUI(){
        
        itemViews = [headerView,itemViewOne,itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -padding),
            ])
            
        }
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
            
            
        ])
        
    }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    


}

extension UserInfoVC: UserInfoVCDelegate{
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else{
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The usrl attached to user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        //
        guard user.followers != 0 else{
            presentGFAlertOnMainThread(title: "No followers", message: "User has no followers", buttonTitle: "Sad")
            return
        }
        delegate.didRequestFollower(for: user.login)
        dismissVC()
    }
    
    
    
}
