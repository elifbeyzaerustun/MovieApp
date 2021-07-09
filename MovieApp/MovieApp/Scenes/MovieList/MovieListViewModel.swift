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
    func filterContentForSearchText(searchText: String)
    func addSearchedMovieModel()
}

class MovieListViewModel {
    
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
        let parm = RequestParameters(language: "en-US", pageNumber: String(pageNumber))
        let request = RequestModel(url: .popularMovies, querryItems: parm.fetchMovieQueryItem)
        NetworkRequestMain.postAction(request, MovieListResponseModel.self) {[weak self] result in
            switch result {
                case .success(let model):
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
}
