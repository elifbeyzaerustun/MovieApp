//
//  UICollectionViewCellExtensions.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import UIKit

extension UICollectionViewCell {
    
    static func register(to collectionView: UICollectionView?) {
        let className = String(describing: Self.self)
        let nib = UINib(nibName: className, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: className)
    }
}
