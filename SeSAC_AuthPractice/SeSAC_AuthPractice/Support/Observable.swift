//
//  Observable.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/27.
//

import Foundation
class Observable<T> {
  private var listener: ((T) -> Void)?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ closure: @escaping (T) -> Void) {
    closure(value)
    listener = closure
  }
  
}
