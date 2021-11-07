//
//  Date+extensions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import Foundation

extension Date {
  
  var dateOnly: Date {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
    let date = Calendar.current.date(from: components)
    return date!
    
  }
  
  var dateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = LocalizableStrings.dateString.localized
    return formatter.string(from: self)
  }
}
