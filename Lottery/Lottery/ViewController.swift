//
//  ViewController.swift
//  Lottery
//
//  Created by hoseung Lee on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
  
  @IBOutlet weak var currentGameNumberLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.delegate = self
    }
  }
  
  @IBOutlet var lotteryBallLabel: [UILabel]! {
    didSet {
      ballUpdate()
    }
  }
  
  @IBOutlet weak var numberPicker: UIPickerView! {
    didSet {
      numberPicker.delegate = self
      numberPicker.dataSource = self
    }
  }
  
  var lotteryCount: [Int] = [1] {
    didSet {
      numberPicker.reloadAllComponents()
      currentGameNumberLabel.text = String(lotteryCount.last!)
      searchTextField.text = String(lotteryCount.last!)
      previousSelect = lotteryCount.count - 1
      requestGame(game: lotteryCount.last!)
      ballUpdate()
    }
  }
  var previousSelect = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateLotteryData()
    
    
    numberPicker.isHidden = true
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
    previousSelect = lotteryCount.count - 1
  }
  
  func updateLotteryData() {
    let url = URL(string: "https://dhlottery.co.kr/gameResult.do?method=byWin")!
    
    var request = URLRequest(url: url)
    request.method = .get
    URLSession(configuration: .default).dataTask(with: request) { data, response, error in
      if let data = data {
        let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
        let context = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR))!
        print(context)
        let substring = #"content="동행복권 986"#
        
        let range = context.range(of: substring)!
        
        var content = context[range]
        
        while let current = content.first {
          if current == " " {
            content.removeFirst()
            break
          } else {
            content.removeFirst()
          }
        }
        DispatchQueue.main.async {
          if let lastGame = Int(content) {
            self.lotteryCount = .init(1...lastGame)
          } else {
            print("Last Game load fail")
          }
        }
      }
    }.resume()
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
    
    AF.request(url, method: .get).validate().responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        
        
        for index in 1...6 {
          self.lotteryBallLabel[index - 1].text = json["drwtNo\(index)"].stringValue
        }
        self.lotteryBallLabel.last!.text = json["bnusNo"].stringValue
        self.dateLabel.text = json["drwNoDate"].stringValue
        self.ballUpdate()

      case .failure(let error):
        print(error)
      }
    }

    
    
  }
  
  func ballUpdate() {
    lotteryBallLabel.forEach { label in
      label.layer.cornerRadius = label.frame.midY
      
      var number = Int(label.text ?? "0")
      if number == nil {
        label.textColor = .black
        number = 0
      }
      switch number! {
      case 1...10:
        label.backgroundColor = .orange
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

extension ViewController: UITextFieldDelegate {
  
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
