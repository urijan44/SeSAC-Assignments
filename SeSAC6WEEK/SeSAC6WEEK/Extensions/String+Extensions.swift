//
//  String+Extensions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/02.
//

import UIKit

extension String {
  func localized(tableName: String = "Localizable") -> String {
    NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: self)
  }
}
