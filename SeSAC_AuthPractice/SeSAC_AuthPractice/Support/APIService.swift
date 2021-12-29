//
//  APIService.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import Foundation

enum APIError: Error {
  case invalidResponse
  case noData
  case failed
  case invalidData
}

class APIService {
  static func login(identifier: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
//    let url = URL(string: "http://test.monocoding.com/auth/local")!
    
    var request = URLRequest(url: Endpoint.login.url)
    request.httpMethod = HTTPMethod.POST.rawValue
    request.httpBody = ("identifier=\(identifier)&password=\(password)").data(using: .utf8)
    
    URLSession.reqeust(endpoint: request, completion: completion)

  }
  
  static func signUp(username: String, email: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
    let url = URL(string: "http://test.monocoding.com/auth/local/register")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
//    let json = ["username": username,
//                "email": email,
//                "password": password]
//    let data = try? JSONSerialization.data(withJSONObject: json, options: /)
//    request.httpBody = data
    request.httpBody = ("username=\(username)&email=\(email)&password=\(password)").data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print(error!)
        completion(nil, .failed)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil, .invalidResponse)
        return
      }
      
      guard let data = data else {
        completion(nil, .noData)
        return
      }
      
      guard let user = try? JSONDecoder().decode(User.self, from: data) else {
        print(String(data: data, encoding: .utf8) ?? "data is empty or encoding error")
        completion(nil, .invalidData)
        return
      }
      completion(user, nil)
    }
    task.resume()
  }
  
  static func lotto(number: Int, completion: @escaping (Lotto?, APIError?) -> Void) {
    
    let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard error == nil else {
        print(error!)
        completion(nil, .failed)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil, .invalidResponse)
        return
      }
      
      guard let data = data else {
        completion(nil, .noData)
        return
      }
      
      guard let lotto = try? JSONDecoder().decode(Lotto.self, from: data) else {
        print(String(data: data, encoding: .utf8) ?? "data is empty or encoding error")
        completion(nil, .invalidData)
        return
      }
      DispatchQueue.main.async {
        completion(lotto, nil)        
      }
    }.resume()
  }
  
  static func actor(text: String, page: Int, person: Person, completion: @escaping (Person?, APIError?) -> Void) {
//  https://api.themoviedb.org/3/search/person?api_key=4c8a93672a9ce99963de02dc377819b7&language=en-US&query=%ED%98%84%EB%B9%88&page=1&include_adult=false&region=ko-KR
    
    
    let scheme = "https"
    let host = "api.themoviedb.org"
    let path = "/3/search/person"
    
    var component = URLComponents()
    component.scheme = scheme
    component.host = host
    component.path = path
    
    guard let apiKey = Bundle.main.infoDictionary?["TMDB"] as? String else {
      completion(nil, .failed)
      return
    }
    
    let apiquery = URLQueryItem(name: "api_key", value: apiKey)
    let langquery = URLQueryItem(name: "language", value: "en-US")
    let searchQuery = URLQueryItem(name: "query", value: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    let pageQuery = URLQueryItem(name: "page", value: page.description)
    let adultFilterQuery = URLQueryItem(name: "include_adult", value: "false")
    let reginQuery = URLQueryItem(name: "region", value: "ko-KR")
    component.queryItems = [apiquery, langquery, searchQuery, pageQuery, adultFilterQuery, reginQuery]
    
    guard let url = component.url else {
      completion(nil, .failed)
      return
    }
    
    requestTask(request: URLRequest(url: url), objectType: person) { person, error in
      DispatchQueue.main.async {
        if let _ = error {
          completion(nil, error)
          return
        }
        
        if let person = person {
          completion(person, nil)
          return
        }
      }
    }
  }

  
  static func fetchBoard(token: String, boardType: BoardElement, completion: @escaping (BoardElement?, APIError?) -> Void) {
    let url = URL(string: "http://test.monocoding.com/boards")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    
    requestTask(request: request, objectType: boardType) { board, error in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        if let _ = error {
          completion(nil, error)
          return
        }
        
        if let board = board {
          completion(board, nil)
          return
        }
      }
    }
  }
  
  fileprivate static func requestTask<T: Decodable>(request: URLRequest, objectType: T, completion: @escaping (T?, APIError?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(nil, .failed)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil, .invalidResponse)
        return
      }
      
      guard let data = data else {
        completion(nil, .noData)
        return
      }

      guard let decoded = try? JSONDecoder().decode([T].self, from: data) else {
        completion(nil, .invalidData)
        return
      }
      completion(decoded.first, nil)
    }
    task.resume()
  }
}
