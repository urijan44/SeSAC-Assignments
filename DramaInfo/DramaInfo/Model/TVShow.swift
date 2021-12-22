//
//  DramaAndTVShow.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import Foundation

struct Results: Decodable {
  var results: [TVShow]
}

struct TVShow: Hashable, Decodable {
  var name: String
  var backdropPath: String?
  var genreIds: [Int]
  var id: Int
  var overview: String
  var posterPath: String?
  var voteAverage: Double
  var releaseDate: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case id
    case overview
    case posterPath = "poster_path"
    case voteAverage = "vote_average"
    case releaseDate = "first_air_date"
  }
}

