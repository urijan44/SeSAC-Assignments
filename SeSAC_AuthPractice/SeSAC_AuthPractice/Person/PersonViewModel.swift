//
//  PersonViewModel.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//

import Foundation
class PersomViewModel {
  
  var person: Observable<Person> = Observable(Person(page: 0, results: [], totalPages: 0, totalResults: 0))
  
  func fetchPerson(query: String, page: Int, completion: @escaping (Person?, APIError?) -> Void) {
    APIService.actor(text: query, page: page, person: person.value) { person, error in
      guard let person = person else {
        completion(nil, error)
        return
      }
      self.person.value.results = []
      self.person.value = person
    }
  }
  
  func resetResult() {
    self.person.value = Person(page: 0, results: [], totalPages: 0, totalResults: 0)
  }
}
