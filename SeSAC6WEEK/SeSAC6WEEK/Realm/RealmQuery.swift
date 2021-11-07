//
//  RealmQuery.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/05.
//

import Foundation
import RealmSwift
import UIKit

extension UIViewController {
  
  func searchQueryFromUserDiary(queryString: String) -> Results<UserDiary> {
    let localRealm = try! Realm()
    let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '\(queryString)'")
    return search
  }
  
  func getAllDiaryCountFromUserDiary() -> Int {
    let localRealm = try! Realm()
    return localRealm.objects(UserDiary.self).count
  }
}

