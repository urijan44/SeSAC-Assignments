//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import Foundation

class ShoppingList {
  static let shared = ShoppingList()
  
  var wishList: [Wish] = []
  
  private let initData = [
    Wish(wishDescription: "그립톡 구매하기", check: true, star: true),
    Wish(wishDescription: "사이다 구매", star: false),
    Wish(wishDescription: "아이패드 케이스 최저가 알아보기", star: true),
    Wish(wishDescription: "양말", star: true),
  ]
  
  private let wishsJSONURL = URL(fileURLWithPath: "Wishs", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("json")
  
  func saveWishs() {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
      let wishsData = try encoder.encode(wishList)
      print(wishsJSONURL)
      try wishsData.write(to: wishsJSONURL, options: .atomic)
      print("save success")
    } catch let error {
      print("save fail")
      print(error.localizedDescription)
    }
  }
  
  func loadWishis() {
    let decoder = JSONDecoder()
    guard let wishData = try? Data(contentsOf: wishsJSONURL) else {
      wishList = initData
      return
    }
    do {
      let wishs = try decoder.decode([Wish].self, from: wishData)
      wishList = wishs
      if wishList.isEmpty {
        wishList = initData
      }
    } catch let error {
      wishList = initData
      print(error)
    }
  }
  
  func addNewWish(wish: Wish) {
    wishList.append(wish)
    saveWishs()
  }
  
}

extension FileManager {
  static var documentDirectoryURL: URL {
    self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
