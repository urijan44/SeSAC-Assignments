//
//  BeerManager.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/21.
//

import Foundation

class BeerManager {
  static var shared = BeerManager()
  
  private init() {}
  
  private let url = URL(string: "https://api.punkapi.com/v2/beers/random")!
  
  func fetchBeer(completion: @escaping (Beer?) -> ()) {
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print(error)
      }
      
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        print(error ?? "response error")
        print("ServerError")
        return
      }
      if let data = data, let beer = try? JSONDecoder().decode([Beer].self, from: data).first {
        completion(beer)
      } else {
        print("decoding error")
      }
    }.resume()
  }
}
