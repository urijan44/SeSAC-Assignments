//
//  EmotionState.swift
//  EmotionDiary
//
//  Created by hoseung Lee on 2021/10/07.
//

import Foundation
enum EmotionState: String, CaseIterable, Codable {
  case 행복해
  case 사랑해
  case 좋아해
  case 당황해
  case 속상해
  case 우울해
  case 심심해
  case 따분해
  case 심란해
  
  func getImageName() -> String {
    switch self {
    case .행복해:
      return "mono_slime1"
    case .사랑해:
      return "mono_slime2"
    case .좋아해:
      return "mono_slime3"
    case .당황해:
      return "mono_slime4"
    case .속상해:
      return "mono_slime5"
    case .우울해:
      return "mono_slime6"
    case .심심해:
      return "mono_slime7"
    case .따분해:
      return "mono_slime8"
    case .심란해:
      return "mono_slime9"
    }
  }
}
