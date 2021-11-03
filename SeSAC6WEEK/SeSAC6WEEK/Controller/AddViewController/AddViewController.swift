//
//  AddViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit
import PhotosUI
import RealmSwift

class AddViewController: UIViewController {
  
  static let identifier = "AddViewController"

  @IBOutlet weak var titleImageView: UIImageView! {
    didSet {
      if diary == nil {
        titleImageView.image = UIImage(systemName: "plus")
      }
    }
  }
  
  @IBOutlet weak var containerForTitle: UIView!
  @IBOutlet weak var titleTextField: UITextField! {
    didSet {
      titleTextField.placeholder = LocalizableStrings.pleaseTypingTitle.localized
    }
  }
  @IBOutlet weak var containerForDate: UIView!
  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      dateLabel.text = Date().dateString
    }
  }
  @IBOutlet weak var diaryDescriptionTextView: UITextView!
  
  var diary: String?
  var isEditingMode = false
  let localRealm = try! Realm()
  
  var editDiary: UserDiary?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    gestureSetup()
    viewStyleSetup()
    keyboardNotificationSetup()
    keyboardToolbarSetup()
    
    if isEditingMode {
      editModeConfigure()
    }
  }
  
  func editModeConfigure() {
    if let diary = editDiary {
      titleTextField.text = diary.title
      dateLabel.text = diary.writeDate.dateString
      diaryDescriptionTextView.text = diary.content
      
      let url = imageFileURL(fileName: "\(diary._id)")
      do {
        let data = try Data(contentsOf: url)
        let image = UIImage(data: data)
        titleImageView.image = image
      } catch let error {
        alertFunction(self, title: LocalizableStrings.alert.localized, body: error.localizedDescription)
      }
    }
  }
  
  func saveImage(imageName: String, image: UIImage) {
    guard let imageDirectory = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)
            .first?
            .appendingPathComponent(
              "image",
              isDirectory: true)
    else { alertFunction(
      self,
      title: LocalizableStrings.alert.localized,
      body: LocalizableStrings.directoryAccessDenied.localized)
      return
    }
    
    let directoryExists = FileManager.default.fileExists(atPath: imageDirectory.path)
    
    if !directoryExists {
      try? FileManager
        .default
        .createDirectory(
          at: imageDirectory.appendingPathComponent("image", isDirectory: true),
          withIntermediateDirectories: true)
    }
    
    let imageURL = imageDirectory.appendingPathComponent(imageName)
    
    guard let data = image.jpegData(compressionQuality: 0.7) else {
      alertFunction(
        self,
        title: LocalizableStrings.alert.localized,
        body: LocalizableStrings.photoSaveFail.localized)
      return
    }
    
    if FileManager.default.fileExists(atPath: imageDirectory.path) {
      do {
        try data.write(to: imageURL, options: .atomic)
      } catch let error {
        print(error)
      }
    }
  }
}

extension AddViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}

//MARK: - DatePickerViewController Delegate
extension AddViewController: DatePickerViewControllerDelegate {
  func datePickerViewController(_ datePickerViewController: DatePickerViewController, didSelectDate date: Date) {
    dateLabel.text = date.dateString
  }
}

//MARK: - PHPickerCiewController Delegate
extension AddViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        guard let self = self, let image = image as? UIImage else { return }
        DispatchQueue.main.async {
          self.titleImageView.image = image
        }
      }
    }
    dismiss(animated: true, completion: nil)
  }
}
