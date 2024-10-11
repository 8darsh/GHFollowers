//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 05/10/24.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews:[UIView] = []
    
    var username: String!
    var dateLabel = GFBodyLabel(textAlignment: .center)
    
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureScrollView()
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
    
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
    }
    
    func getUser(username: String){
       
//        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
//            
//            guard let self else {return}
//            
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async{
//                    self.configureUIElements(with: user)
//                }
//            case .failure(let error):
//                self.presentGFAlert(title: "Unable to show user", message: error.rawValue, buttonTitle: "Ok")
////                self.dismiss(animated: true)
//            }
//        }
        Task{
            
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            }
            catch{
                if let gfError = error as? GFError{
                    presentGFAlert(title: "Unable to show user", message: gfError.rawValue, buttonTitle: "Ok")
                }else{
                    presentDefaultError()
                }
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
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -padding),
            ])
            
        }
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
        
    }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    


}

extension UserInfoVC: GFRepoItemVCDelegate, GFFollowerItemVCDelegate{
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else{
            presentGFAlert(title: "Invalid URL", message: "The usrl attached to user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        //
        guard user.followers != 0 else{
            presentGFAlert(title: "No followers", message: "User has no followers", buttonTitle: "Sad")
            return
        }
        delegate.didRequestFollower(for: user.login)
        dismissVC()
    }
    
    
    
}
