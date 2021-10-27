//
//  TmdbAPIManager.swift.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/28.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MediaType: String {
  case all, movie, tv, person
}

enum TimeWindow: String {
  case day, week
}

class TMDBAPIManager {
  static let shared = TMDBAPIManager()
  private init() {}
  
  private let endPointURL = "https://api.themoviedb.org/3/trending"
  private var apiKey: String {
    guard let apiKey = Bundle.main.infoDictionary?["TMDBKey"]
            as? String else { fatalError("Key Binding Error")}
    return apiKey
  }
  
  func fetchTrendMovieData(page: Int, mediaType: MediaType, timeWindow: TimeWindow, completion: @escaping (Int, JSON) -> ()) {
    guard let url = URL(string: "\(endPointURL)/\(mediaType.rawValue)/\(timeWindow.rawValue)") else { fatalError("url build falure") }
    
    AF.request(url, method: .get, parameters: ["api_key": apiKey, "page": page]).validate(statusCode: 200...500)
      .responseJSON { response in
        switch response.result {
        case .success(let value):
          let code = response.response?.statusCode ?? 500
          completion(code, JSON(value))
        case .failure(let error):
          print(error)
        }
      
      }
    
  }
}
