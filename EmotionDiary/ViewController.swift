//
//  ViewController.swift
//  EmotionDiary
//
//  Created by hoseung Lee on 2021/10/05.
//

import UIKit

class ViewController: UIViewController {
  

  @IBOutlet var emotionImageViewCollection: [UIImageView]!
  @IBOutlet var emotionLableViewCollection: [UILabel]!
  @IBOutlet var emotionStackViewCollection: [UIStackView]!
  
  let manager = EmotionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    
    if manager.emotions.count == emotionImageViewCollection.count {
      for (emotion, eachView) in zip(manager.emotions, emotionImageViewCollection) {
        eachView.image = emotion.image
      }
      for (emotion, eachView) in zip(manager.emotions, emotionLableViewCollection) {
        eachView.text = "\(emotion.emotionState.rawValue) \(emotion.emotionCount)"
        eachView.font = eachView.font.withSize(15)
        eachView.textColor = .black
      }
    }
    
    for (idx, stackView) in emotionStackViewCollection.enumerated() {
      let tapGesture = StackViewTapGesture(target: self, action: #selector(tappedEmotion(sender:)))
      tapGesture.idx = idx
      stackView.addGestureRecognizer(tapGesture)
    }
    
  }
  
  @objc func tappedEmotion(sender: StackViewTapGesture) {
    guard let idx = sender.idx else { return }
    manager.emotions[idx].emotionCount += 1
    updateLable(for: idx)
    
    let origin = emotionImageViewCollection[idx].center.x
    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
      self.emotionImageViewCollection[idx].center.x += 10
    }, completion: nil)
    emotionImageViewCollection[idx].center.x = emotionImageViewCollection[idx].center.x != origin ? origin : emotionImageViewCollection[idx].center.x
    
    
  }
  
  func updateLable(for idx: Int) {
    let emotion = manager.emotions[idx]
    emotionLableViewCollection[idx].text = "\(emotion.emotionState.rawValue) \(emotion.emotionCount)"
    manager.save()
  }
}

class StackViewTapGesture: UITapGestureRecognizer {
  var idx: Int?
}
