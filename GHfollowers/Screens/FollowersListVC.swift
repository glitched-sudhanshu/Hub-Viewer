//
//  FollowerListVCViewController.swift
//  GHfollowers
//
//  Created by Sudhanshu Ranjan on 13/07/24.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var followers: [Follower] = []
    private var pageNo = 1
    private var hasMoreFollowers: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        fetchFollowers(for: username, on: pageNo)
        configureCollectionView()
        configureDataSource()
    }
    
    private func fetchFollowers(for username: String,  on pageNo: Int) {
        NetworkManager.shared.getFollowers(for: username, page: pageNo) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let followers) :
                    print("printing 1 \(followers.count)")
                    if(followers.count < 100) {self.hasMoreFollowers = false}
                    self.followers.append(contentsOf: followers)
                    self.updateData()
                
                case .failure(let error):
                    self.presentGHAlerOnMainThread(
                        title: "Bad Stuff Happend!",
                        message: error.rawValue,
                        buttonText: "Ok"
                    )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView.delegate = self
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding : CGFloat = 12
        let minimumItemSpacing : CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth/3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 35)
        
        return flowLayout
    }
    
    private func configureVC(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            //ask prakhar (casting error happened)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.setFollower(follower: follower)
            return cell
        })
    }
    
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,  animatingDifferences: true)
        }
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            print("calling content 1")
            print("calling content 1: \(pageNo)")
            if offsetY > contentHeight - height {
                print("calling content")
                guard  hasMoreFollowers else {return }
                pageNo += 1
                print("calling content \(pageNo)")
                fetchFollowers(for: username, on: pageNo)
            }
    }
}
