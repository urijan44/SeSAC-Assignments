//
//  MainViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
  let label = UILabel()
  
  let logoutButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = "Welcom"
    
    label.frame = .init(x: view.bounds.midX, y: view.bounds.midY, width: 100, height: 100)
    label.textColor = .white
    view.addSubview(label)
    view.addSubview(logoutButton)
    
    logoutButton.setTitle("로그아웃", for: .normal)
    logoutButton.setTitleColor(.systemRed, for: .normal)
    logoutButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(20)
    }
    
    logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
  }
  
  @objc func logout(_ sender: UIButton) {
    UserDefaults.standard.removeObject(forKey: "userToken")
    UserDefaults.standard.removeObject(forKey: "username")
    UserDefaults.standard.removeObject(forKey: "userId")
    UserDefaults.standard.removeObject(forKey: "userEmail")
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    windowScene.windows.first?.rootViewController = SignUpViewController()
    windowScene.windows.first?.makeKeyAndVisible()
  }
}
