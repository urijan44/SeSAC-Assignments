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

func imageFileURL(fileName: String) -> URL {
  guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("image", isDirectory: true) else { fatalError("App Directory Access Denied")}
  let url = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)
  return url
}
