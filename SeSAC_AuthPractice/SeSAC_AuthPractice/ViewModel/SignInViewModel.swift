//
//  SignInViewModel.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import UIKit

class SignInViewModel {
  var username: Observable<String> = Observable("메밀이")
  var password: Observable<String> = Observable("")
  
  func postUserLogin(completion: @escaping () -> Void) {
    APIService.login(identifier: username.value, password: password.value) { user, error in
      
      guard let user = user else {
        print(error)
        return
      }
      UserDefaults.standard.set(user.jwt, forKey: "userToken")
      UserDefaults.standard.set(user.user.username, forKey: "username")
      UserDefaults.standard.set(user.user.id, forKey: "userId")
      UserDefaults.standard.set(user.user.email, forKey: "userEmail")
      
      completion()
    }
  }
}
