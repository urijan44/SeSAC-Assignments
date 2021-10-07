//
//  Dday.swift
//  AnniversaryCounter
//
//  Created by hoseung Lee on 2021/10/07.
//

import Foundation

struct DDay: Codable {
  var targetDate: Date
  var dday: Int
  var backgroundColor: String
  
  var targetDateText: String {
    let remainDay = Date(timeInterval: Double(dday * 60 * 60 * 24), since: targetDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년\nMM월dd일"
    return formatter.string(from: remainDay)
  }
  
  var ddayText: String {
    return dday > 0 ? "D+\(dday)" : "D-\(dday)"
  }
}


