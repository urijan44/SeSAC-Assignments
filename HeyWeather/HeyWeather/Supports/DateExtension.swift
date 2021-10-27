//
//  DateExtension.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import Foundation

extension Date {
  var customFormatted: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM월 dd일 hh시 mm분"
    return formatter.string(from: Date())
  }
}
