//
//  SignUpViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//

import UIKit

class SignUpViewController: UIViewController {
  
  let mainView = SignUpView()
  let viewModel = SignUpViewModel()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.signUpButton.addTarget(self, action: #selector(sendSignUpRequest), for: .touchUpInside)
    mainView.alreadyID.addTarget(self, action: #selector(showSignInView(_:)), for: .touchUpInside)
    
//    viewModel.name.bind { name in
//      self.mainView.idTextField.text
//    }
//    viewModel.password.bind { pass in
//      self.mainView.passTextField.text
//    }
    
    mainView.idTextField.addTarget(self, action: #selector(idTextFieldDidChanged(_:)), for: .editingChanged)
    mainView.passTextField.addTarget(self, action: #selector(passTextFieldDidChanged(_:)), for: .editingChanged)
    mainView.emailTextFIeld.addTarget(self, action: #selector(emailTextFieldDidChanged(_:)), for: .editingChanged)
  }
  
  @objc func sendSignUpRequest() {
    mainView.signUpButton.configuration?.showsActivityIndicator = true
    mainView.signUpButton.isEnabled = false
    viewModel.postSignUpRequest { user, error in
      DispatchQueue.main.async {
        if let _ = user {
          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          windowScene.windows.first?.rootViewController = MainViewController()
          windowScene.windows.first?.makeKeyAndVisible()
        }
        
        if let error = error {
          let alert = UIAlertController(title: "회원가입 실패", message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(.init(title: "확인", style: .default))
          self.present(alert, animated: true)
        }
        self.mainView.signUpButton.configuration?.showsActivityIndicator = false
        self.mainView.signUpButton.isEnabled = true
      }
    }
    
  }
  
  @objc func showSignInView(_ sender: UIButton) {
    let view = SingInViewController()
    view.modalPresentationStyle = .fullScreen
    present(view, animated: true)
  }
  
  @objc func idTextFieldDidChanged(_ sender: UITextField) {
    viewModel.name.value = sender.text ?? ""
  }
  
  @objc func passTextFieldDidChanged(_ sender: UITextField) {
    viewModel.password.value = sender.text ?? ""
  }
  
  @objc func emailTextFieldDidChanged(_ sender: UITextField) {
    viewModel.email.value = sender.text ?? ""
  }
}
