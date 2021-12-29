//
//  ViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import UIKit

class SingInViewController: UIViewController {
  
  let mainView = SignInView()
  let viewModel = SignInViewModel()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black.withAlphaComponent(0.2)
    mainView.signinHandler = postSignIn
    
//    viewModel.username.bind { username in
//      self.mainView.usernameTextField.text = username
//    }
//    viewModel.password.bind { password in
//      self.mainView.passwordTextField.text = password
//    }
    view.backgroundColor = .systemMint
    mainView.usernameTextField.addTarget(self, action: #selector(userNameTextfieldDidChange(_:)), for: .editingChanged)
    mainView.passwordTextField.addTarget(self, action: #selector(passwordTextfieldDidChange(_:)), for: .editingChanged)
  }
  
  func postSignIn() {
    viewModel.postUserLogin {
      OperationQueue.main.addOperation {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = BoardViewController()
        windowScene.windows.first?.makeKeyAndVisible()
      }
    }
  }
  
  @objc func userNameTextfieldDidChange(_ textField: UITextField) {
    viewModel.username.value = textField.text ?? ""
  }
  
  @objc func passwordTextfieldDidChange(_ textField: UITextField) {
    viewModel.password.value = textField.text ?? ""
  }
}

