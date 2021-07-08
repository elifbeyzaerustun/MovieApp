//
//  UIImageViewExtensions.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import UIKit

extension UIImageView {
    
    func loadImage(with url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
