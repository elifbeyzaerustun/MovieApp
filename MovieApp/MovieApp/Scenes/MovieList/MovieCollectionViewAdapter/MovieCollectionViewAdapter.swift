//
//  MovieCollectionViewAdapter.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

class MovieCollectionViewAdapter: NSObject {
    
    // MARK: Properties
    private enum Constants {
        static let cellName: String = "MovieCollectionViewCell"
        static let numberOfCell: Int = 2
    }
    
    private var collectionView: UICollectionView
    
    // MARK: Init
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setUpCollectionView()
        registerNib()
    }
    
    // MARK: Configurations
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerNib() {
        MovieCollectionViewCell.register(to: collectionView)
    }
    
    func refreshData() {
        collectionView.reloadData()
    }
}

// MARK: Extensions
extension MovieCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellName, for: indexPath) as? MovieCollectionViewCell)!
        return cell
    }
}
