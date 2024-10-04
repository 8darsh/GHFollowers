//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 02/10/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section{ case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var pageNo: Int = 1
    var hasMoreFollowers = true
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
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased())}
        
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
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
