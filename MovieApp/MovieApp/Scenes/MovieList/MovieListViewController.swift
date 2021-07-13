//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    // MARK: Variables
    let defaults = UserDefaults.standard
    
    private var favoriteMoviesIDArray: [Int] = []
    private var movieCollectionViewAdapter: MovieCollectionViewAdapter!
    private var viewModel: MovieListViewModelProtocol!
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel = MovieListViewModel(delegate: self)
        viewModel.fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        hideKeyboardWhenTappedAround()
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
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: Extensions
extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let length = searchBar.text?.count ?? 0
        if length >= 2 {
            viewModel.filterContentForSearchText(searchText: searchText)
            viewModel.addSearchedMovieModel()
            self.movieCollectionViewAdapter.dataSource?.data = viewModel.searchedMovieArray
            self.movieCollectionViewAdapter.refreshData()
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
        
        viewModel.setMoviesDataSourceAndTitleArray(movies: moviesDataSource)
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
        viewModel.configureFetchedMoviesTitleArray()
    }
}

extension MovieListViewController: MovieCollectionViewAdapterDelegate {
    func didSelectItemAt(index: Int) {
        self.performSegue(withIdentifier: "navigateToMovieDetail", sender: index)
    }
}
