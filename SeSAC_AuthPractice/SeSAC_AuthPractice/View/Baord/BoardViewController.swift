//
//  MainViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import UIKit
import SnapKit
import SkeletonView

class BoardViewController: UIViewController {
  let mainView = BoardMainView()
  let viewModel = BoardViewModel()
  let activityView = UIActivityIndicatorView(style: .large)
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gradient = SkeletonGradient(baseColor: .systemGray, secondaryColor: .red)
    mainView.textLable.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.1))
    mainView.usernameLabel.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.1))
    mainView.emailLabel.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.1))
  
    mainView.logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    viewModel.board.bind { board in
      self.mainView.usernameLabel.text = board.usersPermissionsUser.username
      self.mainView.textLable.text = board.text
      self.mainView.emailLabel.text = board.usersPermissionsUser.email
      dump(board)
    }
    
    viewModel.fetchBoard { _, error in
      if let error = error {
        let alert = UIAlertController(title: "알람", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        self.present(alert, animated: true)
      }
      self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))

    }
  }
  
  @objc func logout(_ sender: UIButton) {
    viewModel.logout()
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    windowScene.windows.first?.rootViewController = SignUpViewController()
    windowScene.windows.first?.makeKeyAndVisible()
  }
}
