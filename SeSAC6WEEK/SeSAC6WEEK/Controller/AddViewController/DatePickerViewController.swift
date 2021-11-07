//
//  DatePickerViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

protocol DatePickerViewControllerDelegate {
  func datePickerViewController(_ datePickerViewController: DatePickerViewController, didSelectDate date: Date)
}

class DatePickerViewController: UIViewController {
  
  static let storyboardName = "DatePicker"
  static let identifier = "DatePickerViewController"
  
  @IBOutlet weak var containerView: UIView! {
    didSet {
      containerView.layer.cornerRadius = 8
      containerView.layer.shadowOffset = .init(width: 1, height: 1)
      containerView.layer.shadowOpacity = 0.5
      containerView.layer.shadowRadius = 3
    }
  }
  
  @IBOutlet weak var datePicker: UIDatePicker! {
    didSet {
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
    }
  }
  
  var delegate: DatePickerViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
    view.addGestureRecognizer(dismissGesture)
    
  }
  
  @objc func viewDismiss() {
    delegate?.datePickerViewController(self, didSelectDate: datePicker.date)
    dismiss(animated: true, completion: nil)
  }
}
