//
//  LottoViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//


import UIKit
import SnapKit

class LottoViewController: UIViewController {
  
  let viewModel = LottoViewModel()
  
  var number1 = UILabel()
  var number2 = UILabel()
  var number3 = UILabel()
  var number4 = UILabel()
  var number5 = UILabel()
  var number6 = UILabel()
  var number7 = UILabel()
  
  var dateLabel = UILabel()
  var moneyLabel = UILabel()
  var stackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.spacing = 8
    sv.backgroundColor = .white
    sv.distribution = .fillEqually
    return sv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for (number, label) in zip(viewModel.numbers, [number1, number2, number3, number4, number5, number6, number7]) {
      number.bind { bInt in
        label.text = bInt.description
      }
    }
    
    viewModel.lottoMoney.bind { price in
      self.moneyLabel.text = price.decimalNumber
    }
    moneyLabel.textColor = .white
    moneyLabel.backgroundColor = .lightGray
    
    viewModel.date.bind { date in
      self.dateLabel.text = date
    }
    dateLabel.textColor = .white
    dateLabel.backgroundColor = .lightGray
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.trailing.centerX.centerY.equalToSuperview()
      make.height.equalTo(50)
    }
    
    [number1, number2, number3, number4, number5, number6, number7].forEach { label in
      label.backgroundColor = .lightGray
      stackView.addArrangedSubview(label)
    }
    
    view.addSubview(dateLabel)
    view.addSubview(moneyLabel)
    
    dateLabel.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
    
    moneyLabel.snp.makeConstraints { make in
      make.top.equalTo(dateLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.viewModel.fetchLottoAPI(number: 995) { _, _ in
        
      }
    }
 
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.viewModel.fetchLottoAPI(number: 555) { _, _ in
        
      }
    }
  }
}
