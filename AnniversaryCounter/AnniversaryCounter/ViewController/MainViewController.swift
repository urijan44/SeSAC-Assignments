//
//  ViewController.swift
//  AnniversaryCounter
//
//  Created by hoseung Lee on 2021/10/07.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet var dDayLabels: [UILabel]!
  @IBOutlet var dDayImageViews: [UIImageView]!
  @IBOutlet var targetDates: [UILabel]!
  @IBOutlet var capsuleViews: [UIView]!
  
  var dDayManager = DdayManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dDayManager.load()
    
    //Calendar
    if #available(iOS 14.0, *) {
      datePicker.preferredDatePickerStyle = .inline
    }
    
    //dDayCapule UI
    for (idx, capsule) in capsuleViews.enumerated() {
      capsule.layer.cornerRadius = capsule.frame.width / 8
      capsule.clipsToBounds = true
      
      let tapGesture = DdayViewTapGesture(target: self, action: #selector(dDaySetup(sender:)))
      tapGesture.idx = idx
      capsule.addGestureRecognizer(tapGesture)
    }
    
    updateUI()
  }
  
  @objc func dDaySetup(sender: DdayViewTapGesture) {
    guard let idx = sender.idx else { return }
    let alert = UIAlertController(title: "디데이설정", message: nil, preferredStyle: .alert)
    
    alert.addTextField { afterDay in
      afterDay.placeholder = "숫자만 입력하세요"
      afterDay.keyboardType = .numberPad
    }
    
    alert.addTextField { color in
      color.placeholder = "#FFFFFF"
      color.text = "#"
    }
    
    let ok = UIAlertAction(title: "확인", style: .default) { _ in
      let afterDay = alert.textFields?[0].text ?? ""
      let color = alert.textFields?[1].text ?? ""
      
      if let intAfterDay = Int(afterDay) {
        self.dDayManager.ddays[idx].dday = intAfterDay
      }
      
      if color.count == 7 {
        self.dDayManager.ddays[idx].backgroundColor = color
      }
      
      self.updateUI()
      
    }
    alert.addAction(ok)
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  //UI Reset
  func updateUI() {
    //dDayImageView UI
    for (imageView, dday) in zip(dDayImageViews, dDayManager.ddays) {
      let ddayColor = dday.backgroundColor
      imageView.backgroundColor = UIColor(hexString: ddayColor)
    }
    
    //dDayLabel UI
    for (dDaylabel, dday) in zip(dDayLabels, dDayManager.ddays) {
      dDaylabel.text = dday.ddayText
    }
    
    //dDayTargetDates UI
    for (dDayTarget, dday) in zip(targetDates, dDayManager.ddays) {
      dDayTarget.text = dday.targetDateText
    }
    dDayManager.save()
  }
  
  
  //MARK: - IBActions
  @IBAction func changedDatePicker(_ sender: UIDatePicker) {
    for idx in dDayManager.ddays.indices {
      dDayManager.ddays[idx].targetDate = sender.date
    }
    updateUI()
  }
  
}

class DdayViewTapGesture: UITapGestureRecognizer {
  var idx: Int?
}
