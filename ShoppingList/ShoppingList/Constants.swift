//
//  Constants.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/08.
//

import Foundation

struct Constants {
  static var backupPath: URL {
    URL(fileURLWithPath: "backup", isDirectory: true, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
  }
}
