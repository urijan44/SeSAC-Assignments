//
//  Endpoint.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/29.
//

import UIKit

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
}

enum Endpoint {
  case signup
  case login
  case boards
  case boardDetail(id: Int)
}

extension Endpoint {
  var url: URL {
    switch self {
      case .signup: return .makeEndpoint("auth/local/register")
      case .login: return .makeEndpoint("auth/local")
      case .boards: return .makeEndpoint("boards")
      case .boardDetail(let id): return .makeEndpoint("boards/\(id)")
    }
  }
}

extension URL {
  static let baseURL = "http://test.monocoding.com/"
  
  static func makeEndpoint(_ endpoint: String) -> URL {
    URL(string: baseURL + endpoint)!
  }
}

extension URLSession {
  typealias Handler = (Data?, URLResponse?, Error?) -> Void
  
  @discardableResult
  func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
    let task = dataTask(with: endpoint, completionHandler: handler)
    task.resume()
    return task
  }
  
  static func reqeust<T: Decodable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError?) -> Void) {
    session.dataTask(endpoint) { data, response, error in
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

      guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
        completion(nil, .invalidData)
        return
      }
      completion(decoded, nil)
    }
  }
}
