//
//  User.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import Foundation
struct User: Codable {
  let jwt: String
  let user: UserClass
}

struct UserClass: Codable {
  let id: Int
  let username, email: String
}
