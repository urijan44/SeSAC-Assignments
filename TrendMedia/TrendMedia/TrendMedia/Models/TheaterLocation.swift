//
//  TheaterLocation.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/20.
//

import Foundation

struct TheaterLocation: Decodable {
  let brand: String
  let dong: String
  let latitude: Double
  let longitude: Double
}

class TheaterLocationManager {

  var theaters: [TheaterLocation] = []
  
  var lotteTheaters: [TheaterLocation] {
    theaters.filter { theater in
      theater.brand == "롯데시네마"
    }
  }
  
  var megaboxTheaters: [TheaterLocation] {
    theaters.filter { theater in
      theater.brand == "메가박스"
    }
  }
  
  var cgvTheaters: [TheaterLocation] {
    theaters.filter { theater in
      theater.brand == "CGV"
    }
  }
  
  func load() throws {

    guard let url = Bundle.main.url(forResource: "cinemas", withExtension: "json") else { print("url failure"); return }
    let decoder = JSONDecoder()
    do {
      let data = try Data(contentsOf: url)
      theaters = try decoder.decode([TheaterLocation].self, from: data)
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  init() {
    do {
      try load()
    } catch let error {
      print(error)
    }
  }
}

