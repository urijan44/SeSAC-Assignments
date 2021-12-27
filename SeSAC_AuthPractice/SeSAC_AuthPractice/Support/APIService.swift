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
    let url = URL(string: "http://test.monocoding.com/auth/local")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    //string -> data,
    //dictionary -> JSONSerialization / Codable
    request.httpBody = ("identifier=\(identifier)&password=\(password)").data(using: .utf8)
//    let body = ["identifier": identifier, "password": password]
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print(error!)
        DispatchQueue.main.async {
          completion(nil, .failed)
        }
        return
      }
      
      if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
        print(response)
      } else {
        completion(nil, .invalidResponse)
      }
      
      if let data = data, let user = try? JSONDecoder().decode(User.self, from: data) {
        DispatchQueue.main.async {
          completion(user, nil)
        }
      } else {
        completion(nil, .invalidData)
      }
    }.resume()
    
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
}
