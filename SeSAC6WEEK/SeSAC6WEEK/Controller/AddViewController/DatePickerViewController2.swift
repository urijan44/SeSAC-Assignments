//
//  DatePickerViewController2.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/05.
//


import UIKit

class DatePickerViewController2: UIViewController {
  
  static let identifier = "DatePickerViewController2"
  
  @IBOutlet weak var datePicker: UIDatePicker! {
    didSet {
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
