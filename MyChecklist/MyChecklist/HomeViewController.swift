//
//  HomeViewController.swift
//  MyChecklist
//
//  Created by hoseung Lee on 2021/10/15.
//

import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let presentButton = UIButton()
    presentButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    presentButton.setTitle("Present", for: .normal)
    presentButton.setTitleColor(.white, for: .normal)
    presentButton.setTitleColor(.blue, for: .highlighted)
    presentButton.backgroundColor = .black
    presentButton.layer.cornerRadius = 8
    presentButton.center.x = view.frame.midX
    presentButton.center.y = view.frame.midY
    presentButton.addAction(presnetAction(), for: .touchUpInside)
    presentButton.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//    ])

    view.addSubview(presentButton)
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("willappear")
    view.layoutIfNeeded()
  }
  
  func presnetAction() -> UIAction {

    let uiaction = UIAction { _ in
      guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { fatalError() }
      controller.modalTransitionStyle = .partialCurl
      controller.modalPresentationStyle = .fullScreen
      
      let embedNavigation = UINavigationController(rootViewController: controller)
      controller.modalPresentationStyle = .fullScreen
      embedNavigation.modalPresentationStyle = .fullScreen
      self.present(embedNavigation, animated: true, completion: nil)
    }
    
    
    return uiaction
  }
}
