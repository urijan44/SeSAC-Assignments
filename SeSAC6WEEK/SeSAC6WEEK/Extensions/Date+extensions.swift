//
//  Date+extensions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import Foundation

extension Date {
  var dateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = LocalizableStrings.dateString.localized
    return formatter.string(from: self)
  }
}
