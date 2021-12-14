//
//  ViewController.swift
//  SeSAC054Assignments
//
//  Created by hoseung Lee on 2021/12/14.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

  lazy var melon: UIButton = {
    let button = UIButton()
    button.setTitle("melon", for: .normal)
    button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    button.backgroundColor = .red
    button.isEnabled = true
    return button
  }()
  let kakao = UIButton()
  let delivery = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    kakao.setTitle("kakao", for: .normal)
    delivery.setTitle("delevery", for: .normal)
    
    [melon, kakao, delivery].forEach {
      view.addSubview($0)
    }
    
    melon.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(44)
      make.top.equalToSuperview().offset(60)
    }
    
    kakao.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(44)
      make.top.equalTo(melon.snp.bottom).offset(60)
    }
    
    delivery.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(44)
      make.top.equalTo(kakao.snp.bottom).offset(60)
    }
    
       
    kakao.addTarget(self, action: #selector(showKakao), for: .touchUpInside)
    delivery.addTarget(self, action: #selector(showDelivery), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    melon.addTarget(self, action: #selector(showMelon(_:)) , for: .touchUpInside)
  }
  

  @objc func showMelon(_ sender: UIButton) {
    navigationController?.pushViewController(MelonViewController(), animated: true)
  }
  
  @objc func showKakao() {
    
  }
  
  @objc func showDelivery() {
    
  }

}

