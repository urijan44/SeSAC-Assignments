//
//  SignUpView.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import UIKit
import SwiftUI
import SnapKit

class SignUpView: UIView, ViewRepresenable {

  let idTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "ID를 입력해주세요"
    tf.backgroundColor = .systemGreen.withAlphaComponent(0.7)
    tf.layer.cornerRadius = 8
    tf.textColor = .white
    return tf
  }()
  
  let passTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "암호를 입력해주세요"
    tf.isSecureTextEntry = true
    tf.backgroundColor = .systemGreen.withAlphaComponent(0.7)
    tf.layer.cornerRadius = 8
    tf.textColor = .white
    return tf
  }()
  
  let emailTextFIeld: UITextField = {
    let tf = UITextField()
    tf.placeholder = "이메일을 입력해 주세요"
    tf.keyboardType = .emailAddress
    tf.backgroundColor = .systemGreen.withAlphaComponent(0.7)
    tf.layer.cornerRadius = 8
    tf.textColor = .white
    return tf
  }()
  
  let signUpButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    let bt = UIButton(configuration: configuration)
    bt.setTitle("회원가입 하기", for: .normal)
    bt.setTitleColor(.systemBlue, for: .normal)
    bt.setTitleColor(.systemBlue.withAlphaComponent(0.5), for: .highlighted)
    return bt
  }()
  
  let alreadyID: UIButton = {
    let bt = UIButton()
    bt.setTitle("이미 아이디가 있습니까?", for: .normal)
    bt.setTitleColor(.systemBlue, for: .normal)
    bt.setTitleColor(.systemBlue.withAlphaComponent(0.5), for: .highlighted)
    bt.titleLabel?.font = .systemFont(ofSize: 14)
    return bt
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstrains()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    addSubview(idTextField)
    addSubview(passTextField)
    addSubview(emailTextFIeld)
    addSubview(signUpButton)
    addSubview(alreadyID)
  }
  
  func setupConstrains() {
    idTextField.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(44)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().multipliedBy(0.4)
    }
    
    passTextField.snp.makeConstraints { make in
      make.width.height.centerX.equalTo(idTextField)
      make.top.equalTo(idTextField.snp.bottom).offset(16)
    }
    
    emailTextFIeld.snp.makeConstraints { make in
      make.width.height.centerX.equalTo(passTextField)
      make.top.equalTo(passTextField.snp.bottom).offset(16)
    }
    
    signUpButton.snp.makeConstraints { make in
      make.width.centerX.equalTo(emailTextFIeld)
      make.height.equalTo(44)
      make.top.equalTo(emailTextFIeld.snp.bottom).offset(66)
    }
    
    alreadyID.snp.makeConstraints { make in
      make.width.centerX.equalTo(signUpButton)
      make.height.equalTo(44)
      make.top.equalTo(signUpButton.snp.bottom).offset(128)
    }
    
  }
}

struct SignUpRp: UIViewRepresentable {
  
  func makeUIView(context: UIViewRepresentableContext<SignUpRp>) -> SignUpView {
    SignUpView(frame: .init(x: 0, y: 0, width: 350, height: 848))
  }
  
  func updateUIView(_ uiView: SignUpView, context: Context) {
    
  }
}
struct SignUp_Previews: PreviewProvider {
  static var previews: some View {
    SignUpRp()

  }
}

