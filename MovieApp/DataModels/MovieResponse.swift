//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Dzejlana Redzic on 10/12/20.
//

import Foundation

struct MovieResponse:Decodable{
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Movie]
}

struct Movie:Decodable{
    var poster_path: String?
    var title: String?
    var overview: String?
    var release_date: String?
}
