//
//  TMDBApiManager.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit

class TMDBApiManager {
  static let shared = TMDBApiManager()
  private init() {}
  
  private let searchTvURL = "https://api.themoviedb.org/3/search/tv"
  
  func fetchImage(imageURL: String , isOriginal: Bool = false) -> URL {
//  https://image.tmdb.org/t/p/w500
//  https://image.tmdb.org/t/p/original
    let base = "https://image.tmdb.org/t/p"
    var url = URL(string: base)
    url?.appendPathComponent(isOriginal ? "original" : "w500")
    url?.appendPathComponent(imageURL)
    return url!
  }
  
  func searchTVShow(text: String, page: Int = 1, completion: @escaping ([TVShow]) -> Void) {
    var components = URLComponents(string: searchTvURL)
    
    guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError() }

    let apiKey = URLQueryItem(name: "api_key", value: key)
    let query = URLQueryItem(name: "query", value: text)
    let language = URLQueryItem(name: "language", value: "ko")
    let page = URLQueryItem(name: "page", value: "\(page)")
    
    components?.queryItems = [apiKey, query, language, page]
    
    guard let url = components?.url else { print("urlError"); return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print(error)
      }
      
      if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
        print(response)
      }
      
      if let data = data, let reulsts = try? JSONDecoder().decode(Results.self, from: data) {
        completion(reulsts.results)
      }
    }.resume()
  }
}
