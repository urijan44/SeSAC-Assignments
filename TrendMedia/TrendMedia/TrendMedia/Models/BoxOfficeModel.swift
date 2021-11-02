//
//  BoxOfficeModel.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/11/02.
//

import Foundation

import RealmSwift

class BoxOfficeModel: EmbeddedObject {
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

class BoxOfficeHistory: Object {
  @Persisted(indexed: true) var targetDate: String
  @Persisted var boxOfficeModels: List<BoxOfficeModel>
  
  
  convenience init(targetDate: String, boxOfficeModels: [BoxOfficeModel]) {
    self.init()
    self.targetDate = targetDate
    self.boxOfficeModels.append(objectsIn: boxOfficeModels)
  }
}
