//
//  MovieListResponseModel.swift
//  MovieApp
//
//  Created by Elif Erustun on 7.07.2021.
//

import Foundation

// MARK: MovieListResponseModel
struct MovieListResponseModel: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [MovieResponseModel]?
}
