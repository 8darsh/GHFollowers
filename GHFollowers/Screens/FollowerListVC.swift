//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 02/10/24.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class FollowerListVC: GFDataLoadingVC {
    
    enum Section{ case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageNo: Int = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String){
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureViewController()
        configureCollectionView()
        getFollower(username: username, page: pageNo)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search User"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    
    func getFollower(username: String, page: Int){
        
        showLoadingView()
        // MARK: - After swift 5
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            
            
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
               
                if followers.count < 100 { self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty{
                    let message = "You ain't got followers to show Nigga 😝."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                
                self.updateData(on: self.followers)
            case .failure(let errorMessage):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: errorMessage.rawValue, buttonTitle: "Ok")
            }

        }
    }
    
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            
            cell.set(follower: follower)
            
            
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers) //this append is different from the above
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else {return}
            dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self else { return }
                    guard let error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favourited this user 🎉", buttonTitle: "Hooray!")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

}

extension FollowerListVC: UICollectionViewDelegate{
    
    // Pagination
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        let offsetY =  scrollView.contentOffset.y //user ne kitna scroll kiya hai top to bottom agar user top pr rahega to offsetY 0 hoga jaise jaise scroll karega it'wll increase
        let contentHeight = scrollView.contentSize.height // scrollview mein jo pura content hai uski height
        let height = scrollView.frame.size.height // frame abhi visible kitna hai or phone ki screen u can say
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            pageNo += 1
            getFollower(username: username, page: pageNo)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let activeArray = isSearching ? filteredFollowers: followers
        let follower =  activeArray[indexPath.item]
        
        let userInfoVc = UserInfoVC()
        userInfoVc.delegate = self
        userInfoVc.username = follower.login
        let navController = UINavigationController(rootViewController: userInfoVc)
        
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased())}
        
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
    
}

extension FollowerListVC: FollowerListVCDelegate{
    func didRequestFollower(for username: String) {
        self.username = username
        title = username
        pageNo = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollower(username: username, page: pageNo)
    }
    
    
}










// MARK: - before swift 5


//        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
//
//            guard let followers else {
//                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: errorMessage?.rawValue, buttonTitle: "Ok")
//                return
//            }
//
//            print("followers: \(followers.count)")
//            print(followers)
//        }
