//
//  SettingViewController.swift.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit
import Zip
import MobileCoreServices
import UniformTypeIdentifiers

class SettingViewController: UIViewController {
  
  @IBOutlet weak var settingTabBarItem: UITabBarItem! {
    didSet {
      settingTabBarItem.title = LocalizableStrings.setting.localized
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  /*
   백업하기
   - 사용자의 아이폰 저장공간 확인
    - 부족: 백업 불가
   - 백업 진행
    - 어떤 데이터도 없는 경우라면 백업할 데이터다 없다고 안내
    - realm, forler
    - 백업 중단에 대한 대처(백그라운드, 인터렉션X)
   - zip
    - 백업 완료 tlwjadp
    - Progress + UI 인터렉션 허용
   - 액션
    
   */
  
  func getDocumentDirectoryPath() -> String? {
//    let documnetDirectory = FileManager.SearchPathDirectory.documentDirectory
//    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    guard let directoryPath = path.first else {
      alertFunction(self, title: "", body: "")
      return nil
    }
    return directoryPath
  }
  
  func showActivityViewController() {
    let fileName = (getDocumentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
    let fileURL = URL(fileURLWithPath: fileName)
    
    let activity = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
    
    present(activity, animated: true, completion: nil)
  }
  
  @IBAction func backupData() {
    
    //백업 파일에 대한 URL 배열
    var urls: [URL] = []
    
    urls.append(imageDirectoryURL())
    //디렉토리 폴더 확인
    if let path = getDocumentDirectoryPath() {
      
      //백업하고자 하는 파일 URL 확인
      let realm = (path as NSString).appendingPathComponent("default.realm")
      
      //파일 존재 여부 확인
      if FileManager.default.fileExists(atPath: realm) {
        urls.append(URL(string: realm)!)
        do {
          let zipFilePath = try Zip.quickZipFiles(urls, fileName: "archive")
          print(zipFilePath)
        } catch let error {
          alertFunction(self, title: LocalizableStrings.alert.localized, body: error.localizedDescription)
        }
        showActivityViewController()
      } else {
        print("백업할 파일이 존재하지 않습니다.")
      }
    }
    
  }
  
  @IBAction func showActiviryViewButton(_ sender: UIButton) {
    
    showActivityViewController()
  }
  
  /*
   복구하기
   - 사용자의 아이폰 저장 공간 확인
   - 파일 앱
    - zip
    - zip 선택
   - unzip -> 파일 이름 확인 -> 정상적인 파일인지
   - 백업 데이터 선택
   - 백업 파일 확인
   - 정상적인 파일인지
   -
   */
  @IBAction func dataRestore(_ sender: UIButton) {
    
    //1. 파일 앱 열기
    //import MobileoreServices
    let documnetPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
//    let documnetPicker = UIDocumentPickerViewController(forOpeningContentTypes: [__UTTypeAppleArchive])
    documnetPicker.delegate = self
    documnetPicker.allowsMultipleSelection = false
    present(documnetPicker, animated: true)
  }
}

extension SettingViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
    // 선택파일 경로 가져오기
    guard let selectedFileURL = urls.first else { return }
    
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let sandBoxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
    
    //decompress
    if FileManager.default.fileExists(atPath: sandBoxFileURL.path) {
      
      do {
        let fileURL = URL(fileURLWithPath: "archive.zip", relativeTo: directory)
        try Zip.unzipFile(fileURL, destination: directory, overwrite: true, password: nil) { progress in
          print("progress: \(progress)")
        } fileOutputHandler: { unzippedFile in
          alertFunction(self, title: "알림", body: "백업 파일을 불러왔습니다")
          afterDelay(3) {
            exit(0)
          }
        }

      } catch let error {
        alertFunction(self, title: LocalizableStrings.alert.localized, body: error.localizedDescription)
      }
      
    } else {
      //파일앱에 있는 zip을 도큐먼트 폴더에 복사
      do {
        try FileManager.default.copyItem(at: selectedFileURL, to: sandBoxFileURL)
        let fileURL = URL(fileURLWithPath: "archive.zip", relativeTo: directory)
        try Zip.unzipFile(fileURL, destination: directory, overwrite: true, password: nil) { progress in
          print("progress: \(progress)")
        } fileOutputHandler: { unzippedFile in
          alertFunction(self, title: "알림", body: "백업 파일을 불러왔습니다")
          //데이터베이스 교체시 앱 재실행 필요,
          afterDelay(3) {
            exit(0)
          }
        }
      } catch let error {
        alertFunction(self, title: LocalizableStrings.alert.localized, body: error.localizedDescription)
      }
    }
  }
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print(#function)
    dismiss(animated: true, completion: nil)
  }
}
