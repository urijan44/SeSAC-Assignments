//
//  Wish.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import Foundation

struct Wish: Codable, Equatable {
  var id = UUID().uuidString
  let wishDescription: String
  var check: Bool = false
  var star: Bool = false
}
