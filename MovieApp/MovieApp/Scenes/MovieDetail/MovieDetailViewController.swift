//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import UIKit

class MovieDetailViewController: BaseViewController {
    
    // MARK: Variables
    var movieID: Int?
    
    private var viewModel: MovieDetailViewModelProtocol!
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieOverview: UITextView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(delegate: self)
        viewModel.movieID = movieID
        viewModel.fetchMovieDetail()
        setUpNavBar()
    }
    
    // MARK: IBAction functions
    @IBAction func leftBarButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightBarButtonItemAction() {
        if !viewModel.isFavoriteMovieBool {
            viewModel.addToFavouriteMovies()
            rightBarButtonItem.image = UIImage(systemName: "star.fill")
        } else {
            rightBarButtonItem.image = UIImage(systemName: "star")
            viewModel.removeToFavouriteMovies()
        }
    }
    
    // MARK: Configuration
    private func setUpNavBar() {
        navigationBar.topItem?.title = "Movie Detail"
    }
}

// MARK: Extensions
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func movieDetailFetched(model: MovieResponseModel?) {
        var URLString: String {
            return URLSchema.BaseURLConstants.imageBaseURLW500 + (model?.posterPath ?? "")
        }
        
        DispatchQueue.main.async {
            guard let imageURL = URL(string: URLString) else { return }
            
            self.movieImageView.loadImage(url: imageURL, placeholder: UIImage(named: "dummyMovieImage"))
            self.movieImageView.contentMode = .scaleToFill
            self.movieOverview.text = model?.overview
            self.movieTitleLabel.text = model?.title
            self.voteAverageLabel.text = String(model?.voteAverage ?? 0.0)
            self.viewModel.checkIsFavoriteMovie()
        }
    }
    
    func setAsFavouriteMovie(isFavourite: Bool) {
        
        DispatchQueue.main.async {
            if isFavourite {
                self.rightBarButtonItem.image = UIImage(systemName: "star.fill")
            } else {
                self.rightBarButtonItem.image = UIImage(systemName: "star")
            }
        }
    }
}
