//
//  DataManagerViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/04.
//

import UIKit
import Zip
import RealmSwift
//import MobileCoreServices
//import UniformTypeIdentifiers

class DataManagerViewController: UIViewController {
  
  let archivePath = URL(fileURLWithPath: "archive", relativeTo: Constants.backupPath).appendingPathExtension("zip")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func showActivityViewController() {
    let activity = UIActivityViewController(activityItems: [archivePath], applicationActivities: [])
  
    activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returendItems: [Any]?, error: Error?) in
      if completed {
        try? FileManager.default.removeItem(at: self.archivePath)
        showAlert(self, title: "완료", body: "", onlyOk: true)
      }
    }
    present(activity, animated: true)
  }
  
  @IBAction func backupData() {
    showAlert(self, title: "데이터 백업", body: "데이터를 압축 파일로 백업합니다. \n해당 파일을 안전하게 저장한 뒤, 복구할 때 불러올 수 있습니다. \n파일이 손상되지 않도록 유의해야 합니다.") { [weak self] _ in
      guard let self = self else { return }
      
      let realm = URL(fileURLWithPath: "default.realm", relativeTo: getDocumnetDirectoryPath())

      if FileManager.default.fileExists(atPath: realm.path) {
        do {
          try Zip.zipFiles(paths: [realm], zipFilePath: self.archivePath, password: "1234") { progress in
            print(progress)
            //HUD View
          }
          self.showActivityViewController()
        } catch let error {
          showAlert(self, title: "알림", body: error.localizedDescription, onlyOk: true)
        }
      } else {
        showAlert(self, title: "알림", body: "백업할 파일이 존재하지 않습니다")
      }
    }
  }
  
  @IBAction func restoreData() {
    showAlert(self, title: "데이터 복구", body: "백업된 데이터를 불러옵니다. \n 기존 데이터에 덮어쓰는 작업으로 이전 데이터는 삭제됩니다!") { [weak self] _ in
      guard let self = self else { return }
      let documnetPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive, .zip], asCopy: true)
      documnetPicker.delegate = self
      documnetPicker.allowsMultipleSelection = false
      
      self.present(documnetPicker, animated: true)
    }
  }
}

extension DataManagerViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let selectedUrl = urls.first else { return }
    
    do {
      try FileManager.default.createDirectory(
        at: Constants.backupPath,
        withIntermediateDirectories: true,
        attributes: nil)
      try FileManager.default.copyItem(at: selectedUrl, to: archivePath)
      try Zip.unzipFile(archivePath, destination: Constants.backupPath, overwrite: true, password: "1234", progress: { progress in
        print(progress)
        //progress hud view
      }, fileOutputHandler: { unzippedFile in

      })
      
      let realm = try! Realm()
      let backupRealmURL = Constants.backupPath.appendingPathComponent("default").appendingPathExtension("realm")
      guard FileManager.default.fileExists(atPath: backupRealmURL.path) else {
        showAlert(self, title: "알림", body: "백업 파일 위치를 찾을 수 없습니다", onlyOk: true, handler: nil)
        try? FileManager.default.removeItem(at: Constants.backupPath)
        return
      }
      
      let config = Realm.Configuration(fileURL: backupRealmURL, readOnly: true)
      guard let backupRealm = try? Realm(configuration: config) else{
        showAlert(self, title: "알림", body: "복구에 실패했습니다.", onlyOk: true, handler: nil)
        try? FileManager.default.removeItem(at: Constants.backupPath)
        return
      }
      
      let backupCategory = backupRealm.objects(Category.self)
      do {
        try realm.write {
          for category in backupCategory {
            realm.create(Category.self, value: category, update: .modified)
          }
        }
      } catch let error {
        showAlert(self, title: "알림", body: error.localizedDescription, onlyOk: true, handler: nil)
      }
      
      try FileManager.default.removeItem(at: archivePath)
      try FileManager.default.removeItem(at: Constants.backupPath)
      
      showAlert(self, title: "알림", body: "백업 파일을 불러왔습니다\n", onlyOk: true) { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popToRootViewController(animated: true)
      }
      
    } catch let error {
      try? FileManager.default.removeItem(at: archivePath)
      showAlert(self, title: "알림", body: error.localizedDescription, onlyOk: true)
    }
  }
}
