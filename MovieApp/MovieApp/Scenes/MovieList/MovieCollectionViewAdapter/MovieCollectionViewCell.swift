//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: Variables
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
