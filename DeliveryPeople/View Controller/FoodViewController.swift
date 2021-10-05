//
//  FoodViewController.swift
//  DeliveryPeople
//
//  Created by hoseung Lee on 2021/10/01.
//

import UIKit

class FoodViewController: UIViewController {
  
  @IBOutlet weak var candyButton: UIButton!
  @IBOutlet weak var chocolleteButton: UIButton!
  @IBOutlet weak var chruosButton: UIButton!
  @IBOutlet weak var userSearchField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let keyboardResignGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardResign))
    view.addGestureRecognizer(keyboardResignGesture)
    
    
    //Button UI Init
    [candyButton, chocolleteButton, chruosButton].forEach { button in
      button?.backgroundColor = .orange
      button?.layer.cornerRadius = 5
      button?.sizeToFit()
    }
    
    candyButton.setTitle("사탕", for: .normal)
    chocolleteButton.setTitle("초콜릿", for: .normal)
    chruosButton.setTitle("츄로스", for: .normal)
    
    let codeButton = UIButton()
    codeButton.frame.size.width = view.frame.size.width / 8
    codeButton.frame.size.height = codeButton.frame.size.width * 0.5
    codeButton.frame.origin.x = view.center.x - codeButton.frame.size.width / 2
    codeButton.frame.origin.y = view.center.y - codeButton.frame.size.height / 2
    
    codeButton.setTitle("코드버튼", for: .normal)
    codeButton.backgroundColor = .blue
    let codeButtonGesture = UITapGestureRecognizer(target: self, action: #selector(foodTagInput))
    codeButton.addGestureRecognizer(codeButtonGesture)
    
    view.addSubview(codeButton)
    
    
  }
  
  @objc func keyboardResign() {
    view.endEditing(true)
  }
  
  @objc func foodTagInput() {
    userSearchField.text = "코드코드"
  }
  
  //didEndOnExit
  @IBAction func tappedTextfield() {
    keyboardResign()
  }
  
  @IBAction func tappedFoodTag(_ sender: UIButton) {
    userSearchField.text = sender.currentTitle
  }
}


