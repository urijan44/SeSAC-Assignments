//
//  WebViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class WebViewController: UIViewController {
  
  var navigationBar: UINavigationBar!
  var mediaContent: MediaContent?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let mediaContent = mediaContent else { return }
    setupNavigationBar(mediaContent.title)
    
  }
  
  private func setupNavigationBar(_ title: String) {
    let width = view.frame.width
    navigationBar = UINavigationBar(frame: .init(x: 0, y: 0, width: width, height: 44))
    view.addSubview(navigationBar)
    let navigationItem = UINavigationItem(title: title)
    navigationBar.setItems([navigationItem], animated: false)
    navigationBar.backgroundColor = .clear
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
  }
}
