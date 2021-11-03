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
    if isEditingMode, let diary = editDiary {
      let taskToUpdate = UserDiary(
        title: titleTextField.text!,
        content: diaryDescriptionTextView.text,
        writeDate: dateLabel.text!.dateType!,
        registrationDate: diary.registrationDate)
      
        try! localRealm.write {
          localRealm.create(UserDiary.self,
                            value: ["_id": diary._id,
                                    "title": taskToUpdate.title,
                                    "content": taskToUpdate.content ?? "",
                                    "writeDate": taskToUpdate.writeDate],
                            update: .modified)
          saveImage(imageName: "\(diary._id)", image: titleImageView.image!)
          let hudView = HudView.hud(inView: view, animated: true)
          hudView.text = LocalizableStrings.saveDiary.localized
          
          afterDelay(0.5) {
            hudView.hide()

            self.dismiss(animated: true, completion: nil)
          }
        }
      
    } else {
      let task = UserDiary(title: titleTextField.text!, content: diaryDescriptionTextView.text!, writeDate: Date(), registrationDate: Date())
      try! localRealm.write {
        localRealm.add(task)
        saveImage(imageName: "\(task._id)", image: titleImageView.image!)
        
        let hudView = HudView.hud(inView: view, animated: true)
        hudView.text = LocalizableStrings.saveDiary.localized
        
        afterDelay(0.5) {
          hudView.hide()

          self.dismiss(animated: true, completion: nil)
        }
      }
    }
    
    
  }
  
  @objc func showPhotoPickerView() {
    view.endEditing(true)
    
    if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
      photoMenu()
    } else {
      requestPHPhoroLibraryAuthorization {
        DispatchQueue.main.async {
          self.showPhotoLibrary()
        }
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