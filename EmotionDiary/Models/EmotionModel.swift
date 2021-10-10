//
//  EmotionModel.swift
//  EmotionDiary
//
//  Created by hoseung Lee on 2021/10/06.
//

import UIKit

public struct Emotion: Codable {
  let emotionState: EmotionState
  var emotionCount: Int = 0
  
  var image: UIImage {
    UIImage(named: emotionState.getImageName()) ?? UIImage()
  }
}




