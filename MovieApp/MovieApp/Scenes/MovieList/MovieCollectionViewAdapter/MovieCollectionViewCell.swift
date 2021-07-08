//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: Variables
    static var cellHeight: CGFloat = 240

    var model: MovieResponseModel?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    // MARK: Configuration
    func configure(with model: MovieResponseModel?, isFavorite: Bool?) {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(model?.posterPath ?? "")") else { return }

        self.model = model
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        
        self.titleLabel.text = model?.title
        self.favoriteButton.isHidden = true
        
        self.movieImageView.loadImage(with: imageURL)
        
        if isFavorite == true {
            self.favoriteButton.isHidden = false            
        }
    }
}
