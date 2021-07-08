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
}

class MovieDetailViewModel {
    
    // MARK: Variables
    var movieID: Int?
    var movieDetailDataSource: MovieResponseModel?

    weak var delegate: MovieDetailViewModelDelegate?
    private var pageNumber: Int

    // MARK: Init
    init(delegate: MovieDetailViewModelDelegate?) {
        self.delegate = delegate
        self.pageNumber = 1
        self.movieDetailDataSource = MovieResponseModel(
            movieID: 0,
            title: "",
            overview: "",
            posterPath: "",
            voteAverage: 0.0)
    }
    
    func fetchMovieDetail() {
        let parm = RequestParameters()
        let request = RequestModel(url: .movieDetail(movieID: movieID ?? 0), querryItems: parm.movieDetailQueryItem)
        NetworkRequestMain.postAction(request, MovieResponseModel.self) {[weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let model):
                    self.delegate?.movieDetailFetched(model: model)
                    self.pageNumber += 1
                case .failure:
                    print("error")
            }
        }
    }
}
