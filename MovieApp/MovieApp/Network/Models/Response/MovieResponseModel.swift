//
//  MovieResponseModel.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import Foundation

// MARK: MovieResponseModel
struct MovieResponseModel: Codable {
    let movieID: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
