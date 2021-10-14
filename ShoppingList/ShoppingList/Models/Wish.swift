//
//  Wish.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

struct Wish: Codable, Equatable {
  let wishDescription: String
  var check: Bool = false
  var star: Bool = false
}
