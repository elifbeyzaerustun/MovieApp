//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

// MARK: Protocols
protocol MovieListViewControllerDelegate: AnyObject {
    func initialMoviesFetched(model: MovieListResponseModel?)
    func loadMoreMoviesFetched(model: MovieListResponseModel?)
    func searchMoviesFetched(model: MovieListResponseModel?)
}

class MovieListViewController: UIViewController {

    // MARK: Variables
    var favoriteMoviesIDArray: [Int] = []

    private var movieCollectionViewAdapter: MovieCollectionViewAdapter!
    private var viewModel: MovieListViewModel!

    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadMoreButton: UIButton!

    let defaults = UserDefaults.standard
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel = MovieListViewModel(delegate: self)
        viewModel.fetchMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          
        favoriteMoviesIDArray = defaults.array(forKey: "SavedMoviesIDArray")  as? [Int] ?? [Int]()
        movieCollectionViewAdapter.favoriteMoviesIDArray = favoriteMoviesIDArray
        collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    
    // MARK: IBActions
    @IBAction private func loadMoreButtonClicked() {
        viewModel.fetchMovies()
    }
    
    // MARK: Configuration
    private func configure() {
        setUpCollectionView()
        self.loadMoreButton.setTitle("Load more", for: .normal)
        navigationBar.topItem?.title = "Movies"
        searchBar.placeholder = "Search movie"
        searchBar.delegate = self
        movieCollectionViewAdapter.delegate = self
    }
    
    private func setUpCollectionView() {
        movieCollectionViewAdapter = MovieCollectionViewAdapter(collectionView: collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToMovieDetail" {
            
            guard let destinationView = segue.destination as? MovieDetailViewController else { return }
            guard let index = sender as? Int else { return }
            
            let movieResponse = self.movieCollectionViewAdapter.dataSource?.data?[index]
            
            destinationView.movieID = movieResponse?.movieID
        }
    }
    
    private func isFavoriteMovie() {
        movieCollectionViewAdapter.favoriteMoviesIDArray = favoriteMoviesIDArray
    }
}
    
// MARK: Extensions
extension MovieListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var timer: Timer?
        
        let length = searchBar.text?.count ?? 0
        if length >= 3 {
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                
                self.viewModel.searchMovies(query: searchText)
            })
        }
        
        if length == 0 {
            self.movieCollectionViewAdapter.dataSource?.data?.removeAll()
            self.movieCollectionViewAdapter.dataSource?.data = self.viewModel.moviesDataSource
            self.movieCollectionViewAdapter.refreshData()
        }
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    
    func initialMoviesFetched(model: [MovieResponseModel]?) {
        guard let movies = model else { return }

        self.movieCollectionViewAdapter?.dataSource?.data?.removeAll()
        self.movieCollectionViewAdapter?.dataSource = MovieCollectionViewDataSource(data: movies)
        guard let moviesDataSource = self.movieCollectionViewAdapter?.dataSource?.data else { return }

        self.viewModel.moviesDataSource = moviesDataSource
        self.movieCollectionViewAdapter.refreshData()
        
        isFavoriteMovie()
    }
    
    func loadMoreMoviesFetched(model: [MovieResponseModel]?) {
        guard let movies = model else { return }
        guard let moviesDataSource = self.movieCollectionViewAdapter?.dataSource?.data else { return }

        let temp = MovieCollectionViewDataSource(data: movies)
        self.viewModel.moviesDataSource = moviesDataSource
        self.movieCollectionViewAdapter?.dataSource = temp
        
        self.viewModel.moviesDataSource.append(contentsOf: movies)

        self.movieCollectionViewAdapter.dataSource?.data = self.viewModel.moviesDataSource
        self.movieCollectionViewAdapter.refreshData()
        
        isFavoriteMovie()
    }
    
    func searchMoviesFetched(model: [MovieResponseModel]?) {
        guard let searchMoviesDataSource = self.movieCollectionViewAdapter?.dataSource?.data else { return }

        self.movieCollectionViewAdapter?.dataSource?.data?.removeAll()
        
        self.movieCollectionViewAdapter?.dataSource?.data = model
        self.viewModel.searchMoviesDataSource = searchMoviesDataSource
        self.movieCollectionViewAdapter.refreshData()
        
        isFavoriteMovie()
    }
}

extension MovieListViewController: MovieCollectionViewAdapterDelegate {
    func didSelectItemAt(index: Int) {
        self.performSegue(withIdentifier: "navigateToMovieDetail", sender: index)
    }
}
