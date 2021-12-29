//
//  Board.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/29.
//

import Foundation
// MARK: - BoardElement
struct BoardElement: Codable {
  let id: Int
  let text: String
  let usersPermissionsUser: UsersPermissionsUser
  let createdAt, updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, text
    case usersPermissionsUser = "users_permissions_user"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

// MARK: - UsersPermissionsUser
struct UsersPermissionsUser: Codable {
  let id: Int
  let username, email, provider: String
  let confirmed: Bool
  //    let blocked: JSONNull?
  let role: Int
  let createdAt, updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, username, email, provider, confirmed, role
    //      case blockecd
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}
