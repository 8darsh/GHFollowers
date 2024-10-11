//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 02/10/24.
//

import UIKit



class FollowerListVC: GFDataLoadingVC {
    
    enum Section{ case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageNo: Int = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
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
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && isLoadingMoreFollowers==false{
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No Followers"
            config.secondaryText = "This User has no followers. Go follow them!"
            contentUnavailableConfiguration = config
        }else if isSearching && filteredFollowers.isEmpty{
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        }else{
            contentUnavailableConfiguration = nil
        }
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
        
        searchController.searchBar.placeholder = "Search User"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    
    func getFollower(username: String, page: Int){
        
        showLoadingView()
        isLoadingMoreFollowers = true
        // MARK: - Swift 5.5 Async Await
        Task{
            do{
                
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
               
            }
            catch{
                if let gfError = error as? GFError{
                    presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                }else{
                    presentDefaultError()
                }
                isLoadingMoreFollowers = false
                dismissLoadingView()
            }
            
        }
        
        
        
        // MARK: - After swift 4-5
//        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
//
//
//            guard let self else { return }
//            self.dismissLoadingView()
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//
//            case .failure(let errorMessage):
//                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: errorMessage.rawValue, buttonTitle: "Ok")
//            }
//
//            self.isLoadingMoreFollowers = false
//
//        }
    }
    
    func updateUI(with followers: [Follower]){
        if followers.count < 100 { self.hasMoreFollowers = false}
        self.followers.append(contentsOf: followers)
        self.updateData(on: self.followers)
        setNeedsUpdateContentUnavailableConfiguration()
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

        Task{
            
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            }
            catch{
                if let gfError = error as? GFError{
                    presentGFAlert(title: "Unable to show user", message: gfError.rawValue, buttonTitle: "Ok")
                }else{
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
        
        
        
        
        
        
        
        //        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
        //            guard let self else {return}
        //            dismissLoadingView()
        //
        //            switch result {
        //            case .success(let user):
        //                self.addUserToFavorites(user: user)
        //            case .failure(let error):
        //                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        //            }
        //        }
        
    }
    
    
    func addUserToFavorites(user: User){
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }
            guard let error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success!", message: "You have successfully favourited this user 🎉", buttonTitle: "Hooray!")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
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
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
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

extension FollowerListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            setNeedsUpdateContentUnavailableConfiguration()
            return
        }
        isSearching = true
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    

    
    
}

extension FollowerListVC: UserInfoVCDelegate{
    func didRequestFollower(for username: String) {
        self.username = username
        title = username
        pageNo = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
