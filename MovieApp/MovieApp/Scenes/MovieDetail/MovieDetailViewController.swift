//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: Variables
    var viewModel: MovieDetailViewModel!
    var movieID: Int?
    var favoriteMoviesIDArray: [Int] = []
    var isFavoriteMovieBool: Bool? = false

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
        let defaults = UserDefaults.standard
        
        if isFavoriteMovieBool == false {
            favoriteMoviesIDArray.append(movieID ?? 0)
            defaults.set(favoriteMoviesIDArray, forKey: "SavedMoviesIDArray")
            rightBarButtonItem.image = UIImage(systemName: "star.fill")
            isFavoriteMovieBool = true
        } else {
            if let index = favoriteMoviesIDArray.firstIndex(of: viewModel.movieID ?? 0) {
                favoriteMoviesIDArray.remove(at: index)
                defaults.set(favoriteMoviesIDArray, forKey: "SavedMoviesIDArray")
            }
            isFavoriteMovieBool = false
            rightBarButtonItem.image = UIImage(systemName: "star")
        }
    }
    
    // MARK: Configuration
    func setUpNavBar() {
        navigationBar.topItem?.title = "Movie Detail"
    }

    func isFavoriteMovie() {
        for movieID in favoriteMoviesIDArray {
            if movieID == viewModel.movieID {
                isFavoriteMovieBool = true
                rightBarButtonItem.image = UIImage(systemName: "star.fill")
            }
        }
    }
}

// MARK: Extensions
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func movieDetailFetched(model: MovieResponseModel?) {
        
        DispatchQueue.main.async {
            guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(model?.posterPath ?? "")") else { return }
            let defaults = UserDefaults.standard

            self.movieImageView.loadImage(with: imageURL)
            self.movieImageView.contentMode = .scaleToFill
            self.movieOverview.text = model?.overview
            self.movieTitleLabel.text = model?.title
            self.voteAverageLabel.text = String(model?.voteAverage ?? 0.0)
            
            self.favoriteMoviesIDArray = defaults.array(forKey: "SavedMoviesIDArray")  as? [Int] ?? [Int]()
            self.isFavoriteMovie()
        }
    }
}
