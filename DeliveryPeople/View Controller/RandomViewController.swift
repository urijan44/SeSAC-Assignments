//
//  RandomViewController.swift
//  DeliveryPeople
//
//  Created by hoseung Lee on 2021/09/29.
//

import UIKit
import SwiftUI

class RandomViewController: UIViewController {
  
  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLable.text = """
                      Hello
                      반갑습니다
                      """
    titleLable.textAlignment = .center
    titleLable.backgroundColor = .systemRed
    titleLable.numberOfLines = 2
    titleLable.font = UIFont.boldSystemFont(ofSize: 20)
    titleLable.textColor = .white
    titleLable.layer.cornerRadius = titleLable.frame.size.width / 2
    titleLable.clipsToBounds = true
      
    checkButton.backgroundColor = .magenta
    checkButton.setTitle("행운의 숫자를 뽑아주세요", for: .normal)
    checkButton.setTitle("뽑아 뽑아", for: .highlighted)
    checkButton.layer.cornerRadius = 10
    checkButton.setTitleColor(.white, for: .normal)
  }
  
  @IBAction func tappedRandomNumberButton() {
    let randomNumber = Int.random(in: 1...45)
    titleLable.text = String(randomNumber)
  }
  
}

@available (iOS 13.0, *)
struct ViewControllerPreview: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let randomViewController = RandomViewController()
      return UINavigationController(rootViewController: randomViewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
      
    }
    
    typealias UIViewControllerType = UIViewController
    
    
  }
}
