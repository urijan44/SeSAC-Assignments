//
//  LocalizableStrings.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/02.
//

import Foundation

enum LocalizableStrings: String {
  case home
  case search
  case calendar
  case setting
  case writeDiary
  case pleaseTypingTitle
  case saveBar
  case dateString
  case cancel
  case camera
  case album
  
  var localized: String {
    self.rawValue.localized()
  }
}
