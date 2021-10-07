//
//  ViewController.swift
//  EmotionDiary
//
//  Created by hoseung Lee on 2021/10/05.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var superStackView: UIStackView!
  
  var elements: [UIView] {
    superStackView.subviews.map { $0.subviews }.flatMap { $0 }
  }
  
  let manager = EmotionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    for (emotion, (idx, element)) in zip(manager.emotions, elements.enumerated()) {
      let tapGesture = StackViewTapGesture(target: self, action: #selector(tappedEmotion(sender:)))
      tapGesture.idx = idx
      element.addGestureRecognizer(tapGesture)
      
      if let imageView = element.subviews[0] as? UIImageView {
        imageView.image = emotion.image
      }
      
      if let labelView = element.subviews[1] as? UILabel {
        labelView.text = "\(emotion.emotionState.rawValue) \(emotion.emotionCount)"
        labelView.font = labelView.font.withSize(15)
        labelView.textColor = .black
      }
    }
  }
  
  @objc func tappedEmotion(sender: StackViewTapGesture) {
    guard let idx = sender.idx else { return }
    manager.emotions[idx].emotionCount += 1
    updateLable(for: idx)
    
    let targetImage = elements[idx].subviews[0] as! UIImageView
    let origin = targetImage.center.x
    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
      targetImage.center.x += 10
    }, completion: nil)
    targetImage.center.x = targetImage.center.x != origin ? origin : targetImage.center.x
    
    
  }
  
  func updateLable(for idx: Int) {
    let emotion = manager.emotions[idx]
    let targetLabel = elements[idx].subviews[1] as! UILabel
    targetLabel.text = "\(emotion.emotionState.rawValue) \(emotion.emotionCount)"
    manager.save()
  }
}

class StackViewTapGesture: UITapGestureRecognizer {
  var idx: Int?
}
