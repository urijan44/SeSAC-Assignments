//
//  BoxOfficeModel.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/11/02.
//

import RealmSwift

class BoxOfficeModel: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var rank: String
  @Persisted var title: String
  @Persisted var pubDate: String
  
  convenience init(rank: String, title: String, pubDate: String) {
    self.init()
    self.rank = rank
    self.title = title
    self.pubDate = pubDate
  }
}
