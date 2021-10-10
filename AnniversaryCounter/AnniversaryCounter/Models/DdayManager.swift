//
//  DdayManager.swift
//  AnniversaryCounter
//
//  Created by hoseung Lee on 2021/10/07.
//

import Foundation

class DdayManager {
  var ddays: [DDay] = []
  
  init () {
    load()
    
    if ddays.isEmpty {
      ddays = [
        DDay(targetDate: Date(), dday: 100 , backgroundColor: "#EC007F"),
        DDay(targetDate: Date(), dday: 200, backgroundColor: "#EC007F"),
        DDay(targetDate: Date(), dday: 300, backgroundColor: "#EC007F"),
        DDay(targetDate: Date(), dday: 400, backgroundColor: "#EC007F")
      ]
    }
  }
  
  func save() {
    do {
      let ddaysData = try JSONEncoder().encode(ddays)
      UserDefaults.standard.set(ddaysData, forKey: "\(DdayManager.self)")
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func load() {
    do {
      if let data = UserDefaults.standard.data(forKey: "\(DdayManager.self)") {
        let decoded = try JSONDecoder().decode([DDay].self, from: data)
        ddays = decoded
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
}
