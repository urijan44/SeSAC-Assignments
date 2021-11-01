//
//  DiaryModel.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import Foundation

struct Diary: Codable {
  var id = UUID().uuidString
  var title: String
  var date: Date
  var diaryDescription: String
  var image: String
}
