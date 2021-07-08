//
//  RequestModel.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import Foundation

// MARK: Protocols
protocol QueryParameters {
    var pageNumber: String? { get }
    var language: String? { get }
    var apiKey: String { get }
    var query: String? { get }
}

// MARK: Structs
struct RequestParameters: QueryParameters {
    var language: String? = nil
    var pageNumber: String? = nil
    var query: String? = nil
}

struct RequestModel  {
    let url: URLSchema
    let typeObj: RequestType = .GET
    var querryItems: [URLQueryItem]?
    let httpBody: [String: Any]? = nil
    let param: [String: Any]? = nil
    var httpHeaderField: [String: String]? = nil
}

// MARK: Enums
enum RequestType: String {
    case GET
}

enum NetworkError: Error {
    case domainError
    case decodingError
    case noDataError
}

enum StatusCode: String {
    case successful = "OK"
}

enum URLSchema {
    case popularMovies
    case searchMovies
    case movieDetail(movieID: Int)
    
    private enum EndpointConstants {
        static let popularMovies = "movie/popular"
        static let searchMovies = "search/movie"
        static let movieDetail = "movie/%@"
    }
    
    private enum BaseURLConstants {
        static let baseURL = "https://api.themoviedb.org/3/"
    }
}

// MARK: Extensions
extension URLSchema {
    
    var description: String {
        switch self {
            case .popularMovies:
                return BaseURLConstants.baseURL + EndpointConstants.popularMovies
            case .searchMovies:
                return BaseURLConstants.baseURL + EndpointConstants.searchMovies
            
            case .movieDetail(let movieID):
                return (BaseURLConstants.baseURL + String(format: EndpointConstants.movieDetail, String(movieID)))
        }
    }
}

extension QueryParameters {
    var apiKey: String { return "fd2b04342048fa2d5f728561866ad52a" }
    var language: String { return "en-US" }

    var fetchMovieQueryItem: [URLQueryItem] {
        [URLQueryItem(name: "page", value: pageNumber),
        URLQueryItem(name: "language", value: language),
        URLQueryItem(name: "api_key", value: apiKey)]
    }
    
    var searchMovieQueryItem: [URLQueryItem] {
        [URLQueryItem(name: "page", value: pageNumber),
        URLQueryItem(name: "language", value:language),
        URLQueryItem(name: "api_key", value:apiKey),
        URLQueryItem(name: "query", value: query)]
    }
    
    var movieDetailQueryItem: [URLQueryItem] {
        [URLQueryItem(name: "language", value: language),
        URLQueryItem(name: "api_key", value: apiKey)]
    }
}
