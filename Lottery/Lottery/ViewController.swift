//
//  ViewController.swift
//  Lottery
//
//  Created by hoseung Lee on 2021/10/26.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
  
  @IBOutlet weak var currentGameNumberLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.delegate = self
    }
  }
  
  @IBOutlet var lotteryBallLabel: [UILabel]! {
    didSet {
      lotteryBallLabel.forEach { label in
        label.layer.cornerRadius = label.frame.midY
        
        var number = Int(label.text ?? "0")
        if number == nil {
          label.textColor = .black
          number = 0
        }
        switch number! {
        case 1...10:
          label.backgroundColor = .yellow
        case 11...20:
          label.backgroundColor = .blue
        case 21...30:
          label.backgroundColor = .red
        case 31...40:
          label.backgroundColor = .gray
        case 41...45:
          label.backgroundColor = .green
        default:
          label.backgroundColor = .white
        }
      }
    }
  }
  
  @IBOutlet weak var numberPicker: UIPickerView! {
    didSet {
      numberPicker.delegate = self
      numberPicker.dataSource = self
    }
  }
  
  var lotteryCount: [Int] = .init(333...898)
  var previousSelect = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    numberPicker.isHidden = true
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
    previousSelect = lotteryCount.count - 1
  }
  
  func requestGame(game: Int) {
    var components = URLComponents(string: "https://www.dhlottery.co.kr/common.do")
    let method = URLQueryItem(name: "method", value: "getLottoNumber")
    let game = URLQueryItem(name: "drwNo", value: String(game))
    
    components?.queryItems = [method, game]
    
    
    guard let url = components?.url else {
      print("url build failure")
      return
    }
    
    if let request = try? URLRequest(url: url, method: .get) {
      URLSession.shared.dataTask(with: request) { data, response, error in
        if error == nil {
          print(response ?? "")
          
          if let data = data {
            print(String(data: data, encoding: .utf8) ?? "")
          }
        }
      }.resume()
    }
    
    
  }
  
}

extension ViewController: UITextFieldDelegate {
//
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    numberPicker.isHidden = false
//    numberPicker.selectRow(lotteryCount.count - 1, inComponent: 0, animated: true)
//    UIView.animate(withDuration: 1) {
//      self.view.layoutIfNeeded()
//    }
//  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    numberPicker.isHidden = false
    numberPicker.selectRow(previousSelect, inComponent: 0, animated: true)
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
    return false
  }
  
  
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    lotteryCount.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    "\(lotteryCount[row])회"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    searchTextField.text = "\(lotteryCount[row])"
    currentGameNumberLabel.text = "\(lotteryCount[row])회"
    UIView.animate(withDuration: 0.3) {
//      self.numberPicker.frame.origin.y = self.numberPicker.frame.height + self.numberPicker.frame.origin.y
      self.numberPicker.isHidden = true
    }
    searchTextField.resignFirstResponder()
    previousSelect = row
    requestGame(game: lotteryCount[row])
  }
}
