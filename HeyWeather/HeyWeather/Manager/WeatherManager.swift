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
  
  var weatherData: [String] = [
    "오늘 날씨는 어떤가요?"
  ]
  
  private let apiKey = Bundle.main.infoDictionary?["WeatherAPIKey"] as? String
  
  func fetchWeatherData(_ coordinate: CLLocationCoordinate2D) {
    var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
    let latitudeQuery = URLQueryItem(name: "lat", value: coordinate.latitude.description)
    let longitudeQuery = URLQueryItem(name: "lon", value: coordinate.longitude.description)
    let lang = URLQueryItem(name: "lang", value: "kr")
    let units = URLQueryItem(name: "units", value: "metric")
    
    guard let apiKey = apiKey else { print("api key is empty"); return}
    let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
    
    baseURL?.queryItems = [latitudeQuery, longitudeQuery, lang, units, apiKeyQuery]
    
    guard let url = baseURL?.url else { print("url build fail"); return }
    
    AF.request(url, method: .get).validate().responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.weatherTranslater(data: json)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func weatherTranslater(data: JSON) {
    weatherData.removeAll()
    let temp = data["main"]["temp"].double
    weatherData.append("지금은 \(String(format: "%.1f", temp ?? 0))℃ 에요!")
    
    let humidity = data["main"]["humidity"]
    weatherData.append("\(humidity)% 만큼 습해요!")
    
    let wind = data["wind"]
    weatherData.append("\(wind["deg"]) 방향으로 \(wind["speed"])m/s의 속도로 바람이 불어요")
    
    let weather = data["weather"][0]
    
    weatherData.append("https://openweathermap.org/img/wn/\(weather["icon"])@2x.png")
    weatherData.append("행복한 하루 보내세요")
    
  }
  
  
}
