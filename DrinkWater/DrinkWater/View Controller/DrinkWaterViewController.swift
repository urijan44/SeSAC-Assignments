//
//  ViewController.swift
//  DrinkWater
//
//  Created by hoseung Lee on 2021/10/10.
//

import UIKit

class DrinkWaterViewController: UIViewController {
  
  @IBOutlet var wholeTextUI: [UILabel]!
  @IBOutlet weak var todayDescriptionLabel: UILabel!
  @IBOutlet weak var encorageMessageLabel: UILabel!
  @IBOutlet weak var totalWaterIntakeLabel: UILabel!
  @IBOutlet weak var achivmentLabel: UILabel!
  @IBOutlet weak var cactusImage: UIImageView!
  @IBOutlet weak var footerLabel: UILabel!
  @IBOutlet weak var drinkButton: UIButton! {
    didSet {
      drinkButton.backgroundColor = .white
      drinkButton.setTitleColor(.black, for: .normal)
    }
  }
  @IBOutlet weak var intakeWaterAmountLabel: UILabel!
  var intakeWaterAmount = 0 {
    didSet {
      intakeWaterAmountLabel.text = "\(intakeWaterAmount)ml"
    }
  }
  
  let userManager = UserProfileManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //userProfile이 nil이면 바로 ProfileViewController 이동함
    if userManager.userProfile == nil {
      performSegue(withIdentifier: "ProfileSetup", sender: nil)
    }
    
    //view ui
    view.backgroundColor = UIColor(named: Constants.backgroundColor)
    
    //navigation
    navigationController?.navigationBar.backgroundColor = UIColor(named: Constants.backgroundColor)
    
    
    //labels
    resetLabelColor()
    
    //MARK: intakeWaterAmountUI with Action
    intakeWaterAmountLabel.layer.cornerRadius = intakeWaterAmountLabel.frame.width / 8
    intakeWaterAmountLabel.backgroundColor = UIColor(named: Constants.backgroundHighlightColor)
    let inputIntakeWaterAmountGesture = UITapGestureRecognizer(target: self, action: #selector(inputIntakeWaterAmount))
    intakeWaterAmountLabel.isUserInteractionEnabled = true
    intakeWaterAmountLabel.addGestureRecognizer(inputIntakeWaterAmountGesture)
    intakeWaterAmountLabel.text = "\(intakeWaterAmount)ml"
    
    tooMuchDring()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setImageViewAnimation()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    setImageViewIdentity()
  }
  
  //MARK: 마실 물량 설정 뷰
  @objc func inputIntakeWaterAmount() {
    let alert = UIAlertController(title: "얼마나 마셨나요?", message: nil, preferredStyle: .alert)
    alert.addTextField { waterAmount in
      waterAmount.placeholder = "\(self.intakeWaterAmountLabel.text ?? "")"
      waterAmount.keyboardType = .numberPad
    }
    let ok = UIAlertAction(title: "확인", style: .default) { _ in
      guard let text = alert.textFields?[0].text else { return }
      if !text.isEmpty {
        if let amount = Int(text) {
          if amount < 2000 {
            self.intakeWaterAmount = amount
          } else {
            let waringAlert = UIAlertController(title: "주의", message: "한번에 그만큼이나 마셨을리가 없습니다.", preferredStyle: .alert)
            let close = UIAlertAction(title: "닫기", style: .default, handler: nil)
            
            waringAlert.addAction(close)
            self.present(waringAlert, animated: true, completion: nil)
            
            
          }
        }
      }
    }
    
    alert.addAction(ok)
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: UI Update Methods
  func updateUI() {
    guard let user = userManager.userProfile else { return }
    totalWaterIntakeLabel.text = "\(user.todayWaterIntake)ml"
    let percent = Double(user.todayWaterIntake) / (user.recomendedIntake * 1000) * 100
    achivmentLabel.text = "목표의 \(String(format: "%.2f", percent))%"
    cactusImageUpdate(percent: percent)
    footerLabel.text = "\(user.nickName)님의 하루 물 권장 섭취량은 \(String(format: "%.1f", user.recomendedIntake))l 입니다."
  }
  
  func cactusImageUpdate(percent: Double) {
    switch percent {
    case ..<20:
      cactusImage.image = UIImage(named: Constants.cactusImage1)
      encorageMessageLabel.text = "분발하세요!"
    case 20..<30:
      cactusImage.image = UIImage(named: Constants.cactusImage2)
      encorageMessageLabel.text = "분발하세요!"
    case 30..<40:
      cactusImage.image = UIImage(named: Constants.cactusImage3)
      encorageMessageLabel.text = "분발하세요!"
    case 40..<50:
      cactusImage.image = UIImage(named: Constants.cactusImage4)
      encorageMessageLabel.text = "조금만 더 힘내요!"
    case 50..<60:
      cactusImage.image = UIImage(named: Constants.cactusImage5)
      encorageMessageLabel.text = "조금만 더 힘내요!"
    case 60..<70:
      cactusImage.image = UIImage(named: Constants.cactusImage6)
      encorageMessageLabel.text = "조금만 더 힘내요!"
    case 70..<80:
      cactusImage.image = UIImage(named: Constants.cactusImage7)
      encorageMessageLabel.text = "거의 다 왔어요!"
    case 80..<90:
      cactusImage.image = UIImage(named: Constants.cactusImage8)
      encorageMessageLabel.text = "거의 다 왔어요!"
    case 90..<100:
      cactusImage.image = UIImage(named: Constants.cactusImage9)
      encorageMessageLabel.text = "거의 다 왔어요!"
    case 100...:
      cactusImage.image = UIImage(named: Constants.cactusImage9)
      encorageMessageLabel.text = "잘 하셨어요!"
      [encorageMessageLabel, todayDescriptionLabel, totalWaterIntakeLabel, achivmentLabel].forEach { label in
        label?.textColor = UIColor(named: Constants.goalColor)
      }
    default:
      break
    }
  }
  
  func resetLabelColor() {
    //labels
    wholeTextUI.forEach { label in
      label.textColor = .white
    }
  }
  
  func tooMuchDring() {
    if let todayDrink = userManager.userProfile?.todayWaterIntake {
      if todayDrink > 5000 {
        drinkButton.isUserInteractionEnabled = false
        drinkButton.setTitle("오늘은 그만 마시기", for: .normal)
      }
    }
  }
  
  //MARK: - IBAction
  @IBAction func tappedDrinkAction() {
    userManager.userProfile?.todayWaterIntake += intakeWaterAmount
    intakeWaterAmount = 0
    updateUI()
    userManager.save()
    tooMuchDring()
  }
  
  @IBAction func tappedResetButton() {
    let alert = UIAlertController(title: "알림!", message: "정말 오늘 기록을 초기화 하시겠습니까?", preferredStyle: .alert)
    let ok = UIAlertAction(title: "초기화", style: .destructive) { _ in
      self.userManager.userProfile?.todayWaterIntake = 0
      self.updateUI()
      self.resetLabelColor()
      self.userManager.save()
      
      self.drinkButton.isUserInteractionEnabled = true
      self.drinkButton.setTitle("물 마시기", for: .normal)
      
    }
    alert.addAction(ok)
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
}

extension DrinkWaterViewController {
  private func setImageViewAnimation(){
    UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse, .beginFromCurrentState]) {
      self.cactusImage.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 0.9, y: 0.9)
    }
  }
  
  private func setImageViewIdentity(){
    self.cactusImage.layer.removeAllAnimations()
    self.cactusImage.transform = .identity
  }
}
