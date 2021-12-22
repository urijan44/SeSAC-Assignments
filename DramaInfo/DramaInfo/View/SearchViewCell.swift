//
//  SearchViewCell.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewCell: UICollectionViewCell {
  
  
  var imageBuffer: Data?

  private var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private var activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView()
    view.isHidden = true
    view.backgroundColor = .darkGray
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    layer.cornerRadius = 8
    addSubview(imageView)
    imageView.addSubview(activityView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    activityView.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.equalTo(min(imageView.frame.width, imageView.frame.height))
      make.height.equalTo(min(imageView.frame.width, imageView.frame.height))
    }
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(_ tvShow: TVShow) {
//    imageView.kf.setImage(
//      with: TMDBApiManager.shared.fetchImage(imageURL: tvShow.posterPath ?? ""),
//      placeholder: UIImage(systemName: "film")!,
//      options: [
//        .cacheOriginalImage,
//        .transition(.fade(0.2))
//      ])
    
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    session.dataTask(with: TMDBApiManager.shared.fetchImage(imageURL: tvShow.posterPath ?? "")).resume()
  }
}

extension SearchViewCell: URLSessionDataDelegate {
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
    if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
      imageBuffer = Data()
      activityView.isHidden = false
      activityView.startAnimating()
      return .allow
    } else {
      return .cancel
    }
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    imageBuffer?.append(contentsOf: data)
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
      if let buffer = self.imageBuffer, let image = UIImage(data: buffer) {
        self.imageView.image = image
      }
    } completion: { _ in
      self.activityView.stopAnimating()
      self.activityView.isHidden = true
    }
  }
}
