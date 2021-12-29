//
//  Observable.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/30.
//

import Foundation

class Observable<T> {
  var listener: ((T) -> Void)?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ closure: @escaping ((T) -> Void)) {
    closure(value)
    listener = closure
  }
}
