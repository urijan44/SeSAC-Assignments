//
//  AddViewController+Setup.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

extension AddViewController {
  func viewStyleSetup() {
    [titleImageView, containerForTitle, containerForDate, diaryDescriptionTextView].forEach { view in
      view?.layer.cornerRadius = 8
    }
  }
  
  func navigationBarSetup() {
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.width, height: 44))
    navigationBar.delegate = self
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainExtraBold]
    view.addSubview(navigationBar)
    
    let customNavigationItem = UINavigationItem(title: LocalizableStrings.writeDiary.localized)
    let closeItem: UIBarButtonItem = .init(image: .init(systemName: "multiply"), style: .plain, target: self, action: #selector(closeAddView))
    let saveItem: UIBarButtonItem = .init(title: LocalizableStrings.saveBar.localized, style: .done, target: self, action: #selector(saveDiary))
    
    customNavigationItem.leftBarButtonItem = closeItem
    customNavigationItem.rightBarButtonItem = saveItem
    navigationBar.setItems([customNavigationItem], animated: false)
  }
  
  func gestureSetup() {
    let showPhotoPickerGesture = UITapGestureRecognizer(target: self, action: #selector(showPhotoPickerView))
    titleImageView.addGestureRecognizer(showPhotoPickerGesture)
    titleImageView.isUserInteractionEnabled = true
    
    let showDatePickerViewController = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
    dateLabel.addGestureRecognizer(showDatePickerViewController)
    dateLabel.isUserInteractionEnabled = true
    
    let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
    view.addGestureRecognizer(dismissKeyboardGesture)
    view.isUserInteractionEnabled = true
  }
  
  func keyboardNotificationSetup() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func keyboardToolbarSetup() {
    let toolbar = UIToolbar()
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboardView))
    toolbar.items = [space, done]
    toolbar.sizeToFit()
    
    titleTextField.inputAccessoryView = toolbar
    diaryDescriptionTextView.inputAccessoryView = toolbar
  }
}
