//
//  ProfileViewController.swift
//  DrinkWater
//
//  Created by hoseung Lee on 2021/10/10.
//

import UIKit
import TextFieldEffects

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var nickNameTextField: HoshiTextField!
  @IBOutlet weak var tallTextField: HoshiTextField!
  @IBOutlet weak var weightTextField: HoshiTextField!
  
  let userManager = UserProfileManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //keyboard
    let device = UIDevice.current.name
    if device.contains("SE") || device.contains("pod") {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //userProfile이 nil이면 뒤로가기 버튼 숨기기
    if userManager.userProfile == nil {
      self.navigationItem.setHidesBackButton(true, animated: false)
      navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    } else {
      nickNameTextField.text = userManager.userProfile?.nickName
      tallTextField.text = String(format: "%.1f", userManager.userProfile?.height ?? 0)
      weightTextField.text = String(format: "%.2f", userManager.userProfile?.weight ?? 0)
    }
    
    //view
    view.backgroundColor = UIColor(named: Constants.backgroundColor)
    
    //textField
    let bar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let next = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(nextTextfield))
    let previous = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(previousTextfield))
    bar.items = [flexibleSpace, previous, next]
    bar.sizeToFit()
    [nickNameTextField, tallTextField, weightTextField].forEach { field in
      field?.borderActiveColor = .white
      field?.placeholderColor = .white
      field?.placeholderFontScale = 0.8
      field?.textColor = .white
      field?.delegate = self
      field?.inputAccessoryView = bar
    }
    
    //textfield
    tallTextField.keyboardType = .decimalPad
    weightTextField.keyboardType = .decimalPad
    
    
    let resignKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    view.addGestureRecognizer(resignKeyboardGesture)
  }
  
  
  //MARK: - Helper Methods
  @objc func resignKeyboard() {
    view.endEditing(true)
  }
  
  @objc func nextTextfield() {
    if nickNameTextField.isFirstResponder {
      tallTextField.becomeFirstResponder()
    } else if tallTextField.isFirstResponder {
      weightTextField.becomeFirstResponder()
    } else if weightTextField.isFirstResponder {
      saveProfile()
    }
  }
  
  @objc func previousTextfield() {
    if weightTextField.isFirstResponder {
      tallTextField.becomeFirstResponder()
    } else if tallTextField.isFirstResponder {
      nickNameTextField.becomeFirstResponder()
    }
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height - 150
      }
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(ok)
    
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - IBAction
  @IBAction func saveProfile() {
    guard let nickname = nickNameTextField.text,
            let tall = tallTextField.text,
            let weight = weightTextField.text else { return }
    
    if nickname.isEmpty || tall.isEmpty || weight.isEmpty {
      showAlert("빈칸없이 입력해 주세요")
      return
    }
    
    let tempUserTodayWaterIntake = userManager.userProfile?.todayWaterIntake ?? 0
    
    if let tallNumber = Double(tall), let weightNumber = Double(weight) {
      let setUserProfile = UserProfile(nickName: nickname, height: tallNumber, weight: weightNumber, todayWaterIntake: tempUserTodayWaterIntake, userImage: nil)
      userManager.userProfile = setUserProfile
      userManager.save()
      navigationController?.popViewController(animated: true)
    } else {
      showAlert("키와 몸무게는 숫자만 입력해 주세요!")
      return
    }
  }
}

extension ProfileViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    nextTextfield()
    return true
  }
}
