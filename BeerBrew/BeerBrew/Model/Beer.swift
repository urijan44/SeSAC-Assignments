//
//  Beer.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit

struct Beer: Decodable {
  let name: String
  let origin: String
  let description: String
  let imageURL: String?
  let foodPairing: [String]
  
  var foodPairingCount: Int {
    foodPairing.count
  }
  
  enum CodingKeys: String, CodingKey {
    case name
    case origin = "tagline"
    case description
    case imageURL = "image_url"
    case foodPairing = "food_pairing"
  }
}


