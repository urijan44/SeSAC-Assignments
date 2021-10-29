//
//  MediaContents.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/17.
//

import UIKit

//enum Genre: String, Decodable {
//  case Mystery
//  case Drama
//  case Comedy
//  case Crime
//  case Animation
//  case Documentary
//}



class MediaGenre {
  static let genresRefereces: [Int: String] = [
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western"
  ]
}

struct MediaContent: Decodable {
  var title: String
  var releaseDate: String
  var genre: [Int]
  var region: String
  var overview: String
  var rate: Double
  var starring: String
  var backdropImage: String
  var poster_path: String?
  var mediaID: Int?
  var mediaType: String?
  private var starName: [String] {
    starring.components(separatedBy: ", ").map{String($0)}
  }
  
  var cast: [Cast] {
    var cast: [Cast] = []
    starName.forEach {
      cast.append(Cast(name: $0, image: nil, character: nil))
    }
    return cast
  }
  
  var genresString: String {
    var genresString = ""
    genre.forEach { id in
      genresString.write("#\(MediaGenre.genresRefereces[id] ?? "") ")
    }
    return genresString
  }
  
 
}


  


struct Cast: Decodable {
  let name: String
  let image: String?
  let character: String?
  
  init(name: String, image: String? = nil, character: String? = nil) {
    self.name = name
    self.image = image
    self.character = character
  }
}
