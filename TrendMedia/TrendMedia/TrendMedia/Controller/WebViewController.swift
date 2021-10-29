//
//  WebViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//


import UIKit
import WebKit

class WebViewController: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  
  var navigationBar: UINavigationBar!
  var mediaContent: MediaContent!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requestLink()
  }
  
  func requestLink() {
    guard let mediaID = mediaContent.mediaID else { return }
    
    guard let mediaType = MediaType.init(rawValue: mediaContent.mediaType ?? "") else { return }
    
    TMDBAPIManager.shared.fetchMediaTrailer(mediaID: mediaID, mediaType: mediaType) { code, json in
      switch code {
      case 200:
        var components = URLComponents(string: Constants.URLs.youtubeBaseURL)
        let trailerKey = URLQueryItem(name: "v", value: json["results"][0]["key"].stringValue)
        components?.queryItems = [trailerKey]
        
        guard let url = components?.url else { fatalError("url build failure") }
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.webView.load(request)
        }
      default:
        print(code, json)
      }
    }
  }
}
