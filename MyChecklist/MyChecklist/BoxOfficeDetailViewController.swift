//
//  BoxOfficeDetailViewController.swift
//  MyChecklist
//
//  Created by hoseung Lee on 2021/10/15.
//

import UIKit

class BoxOfficeDetailViewController: UIViewController {
  
  @IBOutlet weak var overviewTextView: UITextView!
  
  let pickerList: [String] = [
  "감자",
  "고구마",
  "호박",
  "당근"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    overviewTextView.delegate = self
    
    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    
    overviewTextView.inputView = pickerView
  }
}

extension BoxOfficeDetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    overviewTextView.text = ""
  }
}


extension BoxOfficeDetailViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    3
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    pickerList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerList[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    overviewTextView.text = pickerList[row]
  }
}


extension BoxOfficeDetailViewController: UIPickerViewDelegate {
  
}
