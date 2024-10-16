//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Adarsh Singh on 01/10/24.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    
    let tableView = UITableView()
    var favorites:[Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()    //if user add favoruite at real time
    }
    
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func getFavourites(){
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let favorites):
                updateUI(with: favorites)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
                
            }
        }
    }
    
    func updateUI(with favorites: [Follower]){
        if favorites.isEmpty{
            self.showEmptyStateView(with: "No Favorites?\n Add one on the following screen", in: self.view)
        }else{
            self.favorites = favorites
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }


}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        cell.set(favorite: favorites[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = UserInfoVC()
        destVC.delegate = self
        destVC.username = favorite.login
        let navVC = UINavigationController(rootViewController: destVC)
        
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        

        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            
            guard let self else {return}
            
            guard let error else{
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty{
                    self.showEmptyStateView(with: "No Favorites?\n Add one on the following screen", in: self.view)
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
            
            
        }
    }
    
    

    
    
}

extension FavoritesListVC: UserInfoVCDelegate{
    func didRequestFollower(for username: String) {
        let destVC = FollowerListVC(username: username)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
}
