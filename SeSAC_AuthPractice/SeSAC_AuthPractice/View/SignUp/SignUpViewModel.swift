//
//  SignUpViewModel.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//

import Foundation

class SignUpViewModel {
  var name: Observable<String> = Observable("")
  var password: Observable<String> = Observable("")
  var email: Observable<String> = Observable("")
  
  func postSignUpRequest(completion: @escaping (User?, APIError?) -> Void) {
    APIService.signUp(username: name.value, email: email.value, password: password.value) { user, error in
      if let error = error {
        completion(nil, error)
        return
      }
      if let user = user {
        
        UserDefaults.standard.set(user.jwt, forKey: "userToken")
        UserDefaults.standard.set(user.user.username, forKey: "username")
        UserDefaults.standard.set(user.user.id, forKey: "userId")
        UserDefaults.standard.set(user.user.email, forKey: "userEmail")

        completion(user, nil)
        return
      }
    }
  }
}
