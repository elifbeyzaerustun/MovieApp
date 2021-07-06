//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate {

    // MARK: Variables
    private var movieCollectionViewAdapter: MovieCollectionViewAdapter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        movieCollectionViewAdapter = MovieCollectionViewAdapter(collectionView: collectionView)
    }
}
