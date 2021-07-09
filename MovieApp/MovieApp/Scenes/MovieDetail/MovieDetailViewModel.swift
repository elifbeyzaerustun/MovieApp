//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import Foundation

// MARK: Protocols
protocol MovieDetailViewModelDelegate: AnyObject {
    func movieDetailFetched(model:  MovieResponseModel?)
    func setAsFavouriteMovie(isFavourite: Bool)
}

protocol MovieDetailViewModelProtocol: AnyObject {
    var movieID: Int? { get set }
    var isFavoriteMovieBool: Bool { get }
    
    func fetchMovieDetail()
    func addToFavouriteMovies()
    func removeToFavouriteMovies()
    func checkIsFavoriteMovie()
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    // MARK: Variables
    var movieID: Int?
    var movieDetailDataSource: MovieResponseModel?
    var isFavoriteMovieBool: Bool
    var favoriteMoviesIDArray: [Int]
    
    let defaults = UserDefaults.standard
    
    weak var delegate: MovieDetailViewModelDelegate?
    
    private var pageNumber: Int
    
    // MARK: Init
    init(delegate: MovieDetailViewModelDelegate?) {
        
        self.delegate = delegate
        self.pageNumber = 1
        
        isFavoriteMovieBool = false
        favoriteMoviesIDArray = []
        
        self.movieDetailDataSource = MovieResponseModel(
            movieID: 0,
            title: "",
            overview: "",
            posterPath: "",
            voteAverage: 0.0)
    }
    
    func addToFavouriteMovies() {
        
        favoriteMoviesIDArray.append(movieID ?? 0)
        defaults.set(favoriteMoviesIDArray, forKey: "SavedMoviesIDArray")
        isFavoriteMovieBool = true
    }
    
    func removeToFavouriteMovies() {
        
        if let index = favoriteMoviesIDArray.firstIndex(of: movieID ?? 0) {
            favoriteMoviesIDArray.remove(at: index)
            defaults.set(favoriteMoviesIDArray, forKey: "SavedMoviesIDArray")
        }
        isFavoriteMovieBool = false
    }
    
    func checkIsFavoriteMovie() {
        for movieID in favoriteMoviesIDArray {
            if movieID == self.movieID {
                isFavoriteMovieBool = true
                delegate?.setAsFavouriteMovie(isFavourite: true)
            }
        }
    }
    
    func fetchMovieDetail() {
        showLoadingIndicator()
        let parm = RequestParameters()
        let request = RequestModel(url: .movieDetail(movieID: movieID ?? 0), querryItems: parm.movieDetailQueryItem)
        
        NetworkRequestMain.postAction(request, MovieResponseModel.self) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                hideLoadingIndicator()
                self.delegate?.movieDetailFetched(model: model)
                self.pageNumber += 1
                self.favoriteMoviesIDArray = self.defaults.array(forKey: "SavedMoviesIDArray")  as? [Int] ?? [Int]()
            case .failure:
                print("error")
            }
        }
    }
}
