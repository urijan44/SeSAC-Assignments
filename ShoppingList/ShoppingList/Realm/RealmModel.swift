//
//  RealmModel.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/02.
//

import Foundation
import RealmSwift

class UserWish: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var wishDescription: String
  @Persisted var check: Bool
  @Persisted var star: Bool
  
  convenience init(wishDescription: String) {
    self.init()
    
    self.wishDescription = wishDescription
    self.check = false
    self.star = false
  }
}

class Category: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var category: String
  @Persisted var wishList: List<UserWish>
  
  convenience init(category: String) {
    self.init()
    self.category = category
  }
}
