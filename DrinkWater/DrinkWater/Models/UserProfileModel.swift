//
//  UserProfileModel.swift
//  DrinkWater
//
//  Created by hoseung Lee on 2021/10/10.
//

import Foundation

struct UserProfile: Codable {
  var nickName: String
  var height: Double
  var weight: Double
  var todayWaterIntake: Int
  var userImage: String?
  
  var recomendedIntake: Double {
    (height + weight) / 100
  }
  
}

class UserProfileManager {
  static let shared = UserProfileManager()
  var userProfile: UserProfile?
  init() {
    load()
    if userProfile == nil {
      print("UserProfile is nil")
    }
  }
  
  func save() {
    do {
      let userData = try JSONEncoder().encode(userProfile)
      UserDefaults.standard.set(userData, forKey: "\(UserProfileManager.self)")
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func load() {
    do {
      if let data = UserDefaults.standard.data(forKey: "\(UserProfileManager.self)") {
        let decoded = try JSONDecoder().decode(UserProfile.self, from: data)
        userProfile = decoded
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
