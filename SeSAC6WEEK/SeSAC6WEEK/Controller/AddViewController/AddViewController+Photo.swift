//
//  AddViewController+Photo.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import PhotosUI
import UIKit

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
  
  func photoMenu() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: LocalizableStrings.cancel.localized, style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    let takePhoto = UIAlertAction(
      title: LocalizableStrings.camera.localized, style: .default) { [weak self] _ in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.showCameraView()
        }
      }
    alert.addAction(takePhoto)
    
    let choosePhotoFromLibrary = UIAlertAction(
      title: LocalizableStrings.album.localized, style: .default) { [weak self] _ in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.showPhotoLibrary()
        }
      }
    alert.addAction(choosePhotoFromLibrary)
    
    present(alert, animated: true)
  }
  
  func showPhotoLibrary() {
    var configuration = PHPickerConfiguration()
    configuration.filter = .any(of: [.images, .livePhotos])
    configuration.selectionLimit = 1
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    self.present(picker, animated: true, completion: nil)
  }
  
  private func showCameraView() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      titleImageView.image = image
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
