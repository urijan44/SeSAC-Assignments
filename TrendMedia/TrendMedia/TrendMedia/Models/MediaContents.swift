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

struct MediaContent: Decodable {
  var title: String
  var releaseDate: String
  var genre: String
  var region: String
  var overview: String
  var rate: Double
  var starring: String
  var backdropImage: String
  var poster_path: String?
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
