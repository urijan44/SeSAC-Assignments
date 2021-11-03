//
//  AlertView.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import UIKit

func alertFunction(_ viewController: UIViewController, title: String, body: String) {
  let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
  let ok = UIAlertAction(title: LocalizableStrings.ok.localized, style: .default)
  let cancel = UIAlertAction(title: LocalizableStrings.cancel.localized, style: .cancel)
  
  [ok, cancel].forEach { action in
    alert.addAction(action)
  }
  
  viewController.present(alert, animated: true)
}
