//
//  RealmModel.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/02.
//

import Foundation
import RealmSwift

class UserDiary: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var title: String
  @Persisted var content: String?
  @Persisted var writeDate = Date()
  @Persisted var registrationDate = Date()
  @Persisted var favorite: Bool
  
  convenience init(title: String, content: String?, writeDate: Date, registrationDate: Date) {
    self.init()
    self.title = title
    self.content = content
    self.writeDate = writeDate
    self.registrationDate = registrationDate
    self.favorite = false
  }
}
