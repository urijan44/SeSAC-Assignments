//
//  Functions.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/04.
//

import UIKit

func getDocumnetDirectoryPath() -> URL {
  return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}



func showAlert(_ controller: UIViewController, title: String, body: String, onlyOk: Bool = false, handler: ((UIAlertAction) -> Void)? = nil) {
  let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
  let ok = UIAlertAction(title: "확인", style: .destructive, handler: handler)
  alert.addAction(ok)
  
  if !onlyOk {
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    alert.addAction(cancel)
  }
  
  controller.present(alert, animated: true, completion: nil)
}

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
