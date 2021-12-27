//
//  SIgnInView.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//


import UIKit
import SnapKit



class SignInView: UIView, ViewRepresenable {
  func setupView() {
    [usernameTextField, passwordTextField, signInButton].forEach { sub in
      addSubview(sub)
      sub.backgroundColor = .systemTeal
      sub.layer.cornerRadius = 8
    }

    usernameTextField.placeholder = "아이디를 입력해 주세요"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.placeholder = "비밀번호를 입력해 주세요"
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.setTitleColor(.black, for: .highlighted)
    signInButton.backgroundColor = .systemOrange
    signInButton.addTarget(self, action: #selector(postSignin), for: .touchUpInside)
  }
  
  func setupConstrains() {
    usernameTextField.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(44)
      make.centerX.centerY.equalToSuperview()
    }
    
    passwordTextField.snp.makeConstraints { make in
      make.width.height.centerX.equalTo(usernameTextField)
      make.top.equalTo(usernameTextField.snp.bottom).offset(16)
    }
    
    signInButton.snp.makeConstraints { make in
      make.width.height.centerX.equalTo(usernameTextField)
      make.top.equalTo(passwordTextField.snp.bottom).offset(16)
    }
    
  }
  
  let usernameTextField = UITextField()
  let passwordTextField = UITextField()
  let signInButton = UIButton()
  var signinHandler: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstrains()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  @objc func postSignin() {
    signinHandler?()
  }
}

import SwiftUI

struct SignInRepresent: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<SignInRepresent>) -> SignInView {
    SignInView(frame: .init(x: 0, y: 0, width: 350, height: 842))
  }
  
  func updateUIView(_ uiView: SignInView, context: Context) {
    
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInRepresent()
      .previewLayout(.sizeThatFits)
  }
}
