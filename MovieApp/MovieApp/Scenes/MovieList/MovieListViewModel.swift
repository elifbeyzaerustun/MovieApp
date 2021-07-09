//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import Foundation

// MARK: Protocols

protocol MovieListViewModelDelegate: AnyObject {
    func initialMoviesFetched(model:  [MovieResponseModel]?)
    func loadMoreMoviesFetched(model: [MovieResponseModel]?)
}

protocol MovieListViewModelProtocol: AnyObject {
    var moviesDataSource: [MovieResponseModel] { get set }
    var searchedMovieArray: [MovieResponseModel] { get set }
    var filteredMovieTitleArray: [String] { get }
    var fetchedMoviesTitleArray: [String] { get }
    
    func fetchMovies()
    func addSearchedMovieModel()
    func filterContentForSearchText(searchText: String)
    func setMoviesDataSourceAndTitleArray(movies: [MovieResponseModel])
    func configureFetchedMoviesTitleArray()
}

class MovieListViewModel: MovieListViewModelProtocol {
    
    // MARK: Variables
    var moviesDataSource: [MovieResponseModel]
    var searchedMovieArray: [MovieResponseModel] = []
    var filteredMovieTitleArray = [String]()
    var fetchedMoviesTitleArray = [String]()
    
    weak var delegate: MovieListViewModelDelegate?
    
    private var pageNumber: Int
    
    // MARK: Init
    init(delegate: MovieListViewModelDelegate?) {
        self.delegate = delegate
        self.pageNumber = 1
        self.moviesDataSource = []
    }
    
    // MARK: Network requests
    func fetchMovies() {
        showLoadingIndicator()
        
        let parm = RequestParameters(language: "en-US", pageNumber: String(pageNumber))
        let request = RequestModel(url: .popularMovies, querryItems: parm.fetchMovieQueryItem)
        NetworkRequestMain.postAction(request, MovieListResponseModel.self) {[weak self] result in
            
            switch result {
            case .success(let model):
                hideLoadingIndicator()
                if self?.pageNumber == 1 {
                    self?.delegate?.initialMoviesFetched(model: model.results)
                } else {
                    self?.delegate?.loadMoreMoviesFetched(model: model.results)
                }
                self?.pageNumber += 1
            case .failure:
                print("error")
            }
        }
    }
    
    // MARK: Search movie functions
    func addSearchedMovieModel() {
        var searchedMovieArray: [MovieResponseModel] = []
        
        for model in moviesDataSource {
            for title in filteredMovieTitleArray {
                if title == model.title {
                    searchedMovieArray.append(model)
                }
            }
        }
        self.searchedMovieArray = searchedMovieArray
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredMovieTitleArray = fetchedMoviesTitleArray.filter { term in
            return term.lowercased().contains(searchText.lowercased())
        }
    }
    
    func setMoviesDataSourceAndTitleArray(movies: [MovieResponseModel]) {
        moviesDataSource = movies
        for model in moviesDataSource {
            fetchedMoviesTitleArray.append(model.title ?? "")
        }
    }
    
    func configureFetchedMoviesTitleArray() {
        fetchedMoviesTitleArray.removeAll()
        for model in moviesDataSource {
            fetchedMoviesTitleArray.append(model.title ?? "")
        }
    }
}
