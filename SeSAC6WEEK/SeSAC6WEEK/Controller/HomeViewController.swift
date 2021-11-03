//
//  HomeViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSetup()
    
  }
  
  private func navigationBarSetup() {
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.width, height: 44))
    navigationBar.delegate = self
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainExtraBold]
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    
    view.addSubview(navigationBar)
    
    let customNavigationItem = UINavigationItem(title: "HOME")
    let addItem: UIBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(showAddViewController))
    
    customNavigationItem.rightBarButtonItem = addItem
    navigationBar.setItems([customNavigationItem], animated: false)
  }
  
  @objc func showAddViewController() {
    guard let controller = UIStoryboard(name: "Content", bundle: nil)
            .instantiateViewController(withIdentifier: AddViewController.identifier)
            as? AddViewController else { fatalError("AddViewController load failure") }
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true, completion: nil)
    
  }
}

extension HomeViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}
