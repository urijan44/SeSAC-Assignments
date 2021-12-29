//
//  BoardViewModel.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/29.
//

import Foundation

class BoardViewModel {
  
  var board: Observable<BoardElement> = Observable(BoardElement(id: -1, text: "", usersPermissionsUser: UsersPermissionsUser(id: -1, username: "", email: "", provider: "", confirmed: false, role: 0, createdAt: "", updatedAt: ""), createdAt: "", updatedAt: ""))
  
  let token = UserDefaults.standard.string(forKey: "userToken")
  
  func logout() {
    UserDefaults.standard.removeObject(forKey: "userToken")
    UserDefaults.standard.removeObject(forKey: "username")
    UserDefaults.standard.removeObject(forKey: "userId")
    UserDefaults.standard.removeObject(forKey: "userEmail")
  }
  
  func fetchBoard(completion: @escaping (BoardElement?, APIError?) -> Void) {
    if let token = token {
      APIService.fetchBoard(token: token, boardType: board.value) { fetchedBoard, error in
        
        if let error = error {
          completion(nil, error)
          return
        }
        
        if let fetchedBoard = fetchedBoard {
          self.board.value = fetchedBoard
          completion(fetchedBoard, nil)
        }

      }
    } else {
      completion(nil, .none)
    }
    
  }
}
