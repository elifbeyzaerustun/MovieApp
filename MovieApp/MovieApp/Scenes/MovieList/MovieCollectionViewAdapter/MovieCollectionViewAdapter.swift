//
//  MovieCollectionViewAdapter.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

// MARK: Protocols
protocol MovieCollectionViewAdapterDelegate: AnyObject {
    func didSelectItemAt(index: Int)
}

// MARK: Structs
struct MovieCollectionViewDataSource {
    var data: [MovieResponseModel]? = []
}

class MovieCollectionViewAdapter: NSObject {
    
    // MARK: Properties
    var dataSource: MovieCollectionViewDataSource?
    var favoriteMoviesIDArray: [Int] = []
    var isFavoriteMovie: Bool?
    
    weak var delegate: MovieCollectionViewAdapterDelegate?
    
    private var collectionView: UICollectionView
    
    private enum Constants {
        static let cellName: String = "MovieCollectionViewCell"
        static let numberOfCell: Int = 2
    }
    
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: Extensions
extension MovieCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(collectionView, cellForItemAt: indexPath)
    }

    func configureCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MovieCollectionViewCell {
        let cell: MovieCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellName, for: indexPath) as? MovieCollectionViewCell)!
        let index = indexPath.row
        
        if let item = dataSource?.data?[index] {
            isFavoriteMovie = false

            for movieID in favoriteMoviesIDArray {
                if movieID == item.movieID {
                    isFavoriteMovie = true
                }
            }
            cell.configure(with: item, isFavorite: isFavoriteMovie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat =  10
           let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / CGFloat(Constants.numberOfCell), height: MovieCollectionViewCell.cellHeight)
       }
}
