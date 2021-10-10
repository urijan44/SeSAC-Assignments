//
//  EmotionManager.swift
//  EmotionDiary
//
//  Created by hoseung Lee on 2021/10/07.
//

import Foundation
class EmotionManager {
  var emotions: [Emotion] = []
  
  init() {
    
    load()
    
    if emotions.isEmpty {
      for state in EmotionState.allCases {
        let emotion = Emotion(emotionState: state)
        emotions.append(emotion)
      }
    }
  }
  
  func save() {
    do {
      let emotionData = try JSONEncoder().encode(emotions)
      UserDefaults.standard.set(emotionData, forKey: "\(EmotionManager.self)")
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func load() {
    do {
      if let data = UserDefaults.standard.data(forKey: "\(EmotionManager.self)") {
        let decoded = try JSONDecoder().decode([Emotion].self, from: data)
        emotions = decoded
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
}
