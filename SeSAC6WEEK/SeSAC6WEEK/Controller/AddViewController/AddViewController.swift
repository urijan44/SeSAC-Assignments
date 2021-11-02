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
  let localRealm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    gestureSetup()
    viewStyleSetup()
    keyboardNotificationSetup()
    keyboardToolbarSetup()
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
