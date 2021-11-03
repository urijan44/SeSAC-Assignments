//
//  Functions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping() -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
