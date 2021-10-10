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
    
    //userProfile이 nil이면 뒤로가기 버튼 숨기기
    if userManager.userProfile == nil {
      print("userProfile nil")
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
    [nickNameTextField, tallTextField, weightTextField].forEach { field in
      field?.borderActiveColor = .white
      field?.placeholderColor = .white
      field?.placeholderFontScale = 0.8
      field?.textColor = .white
      field?.delegate = self
    }
    
    //textfield
    tallTextField.keyboardType = .decimalPad
    weightTextField.keyboardType = .decimalPad
    
    
    let resignKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    view.addGestureRecognizer(resignKeyboardGesture)
  }
  
  @objc func resignKeyboard() {
    view.endEditing(true)
  }
  
  
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
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(ok)
    
    present(alert, animated: true, completion: nil)
  }
}

extension ProfileViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if nickNameTextField.isFirstResponder {
      tallTextField.becomeFirstResponder()
    } else if tallTextField.isFirstResponder {
      weightTextField.becomeFirstResponder()
    } else if weightTextField.isFirstResponder {
      saveProfile()
    }
    return true
  }
}
