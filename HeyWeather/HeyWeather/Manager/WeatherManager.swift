//
//  WeatherManager.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import CoreLocation
import Alamofire
import SwiftyJSON

class WheatherManager {
  
  static let shared = WheatherManager()
  
  init() {}
  
  private let apiKey = Bundle.main.infoDictionary?["WeatherAPIKey"] as? String
  
  private func getURL(coordinate: CLLocationCoordinate2D) -> URL {
    var baseURL = URLComponents(string: Constants.URLs.openWeatherAPIEndPoint)
    
    let latitudeQuery = URLQueryItem(name: "lat", value: coordinate.latitude.description)
    let longitudeQuery = URLQueryItem(name: "lon", value: coordinate.longitude.description)
    let lang = URLQueryItem(name: "lang", value: "kr")
    let units = URLQueryItem(name: "units", value: "metric")
    
    guard let apiKey = apiKey else { print("api key is empty"); fatalError("API KEY load fail")}
    let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
    
    baseURL?.queryItems = [latitudeQuery, longitudeQuery, lang, units, apiKeyQuery]
    
    guard let url = baseURL?.url else { print("url build fail"); fatalError("URL Build Fail") }
    
    return url
  }
  
  func fetchWeatherData(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Int, JSON) -> ()) {
    
    let url = getURL(coordinate: coordinate)
    
    AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
      switch response.result {
      case .success(let value):
        
        let code = response.response?.statusCode ?? 500
        completion(code, JSON(value))
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
