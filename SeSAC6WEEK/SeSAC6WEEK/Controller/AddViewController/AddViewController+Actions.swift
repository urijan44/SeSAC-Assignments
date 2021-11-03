//
//  AddViewController+Actions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//
import UIKit
import PhotosUI

extension AddViewController {
  @objc func closeAddView() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func saveDiary() {
    let task = UserDiary(title: titleTextField.text!, content: diaryDescriptionTextView.text!, writeDate: Date(), registrationDate: Date())
    
    try! localRealm.write {
      localRealm.add(task)
      saveImage(imageName: "\(task._id)", image: titleImageView.image!)
    }
    dismiss(animated: true, completion: nil)
  }
  
  @objc func showPhotoPickerView() {
    view.endEditing(true)
    
    requestPHPhoroLibraryAuthorization {
      DispatchQueue.main.async {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
      }
    }
  }
  
  func requestPHPhoroLibraryAuthorization(completion: @escaping () -> ()) {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
      switch authorizationStatus {
      case .limited:
        completion()
      case .authorized:
        completion()
      default:
        return
      }
    }
  }
  
  @objc func showDatePicker() {
    guard let controller = UIStoryboard(name: DatePickerViewController.storyboardName, bundle: nil)
            .instantiateViewController(withIdentifier: DatePickerViewController.identifier)
            as? DatePickerViewController else { fatalError("DatePickerViewController load failure")}
    
    controller.modalTransitionStyle = .crossDissolve
    controller.modalPresentationStyle = .overFullScreen
    controller.delegate = self
    present(controller, animated: true, completion: nil)
  }
  
  @objc func dismissKeyboardView() {
    view.endEditing(true)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if view.bounds.origin.y == 0 {
        view.bounds.origin.y += keyboardSize.height
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    view.bounds.origin.y = 0
  }
}
