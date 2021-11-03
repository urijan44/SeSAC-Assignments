//
//  DetailViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
  
  static let identifier = "DetailViewController"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var diaryImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  
  var userDiary: UserDiary!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    uiSetup()
    configure()
    navigationSetup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = false
  }
  
  func uiSetup() {
    titleLabel.font = UIFont.mainExtraBold
    diaryImageView.contentMode = .scaleAspectFit
  }
  
  func configure() {
    titleLabel.text = userDiary.title
    dateLabel.text = userDiary.writeDate.dateString
    contentTextView.text = userDiary.content
    
    
    let url = URL(
      fileURLWithPath: "\(userDiary._id)",
      relativeTo: FileManager.default.urls(
        for: .documentDirectory,
           in: .userDomainMask)[0]
        .appendingPathComponent("image", isDirectory: true))
    do {
      let data = try Data(contentsOf: url)
      let image = UIImage(data: data)
      diaryImageView.image = image
    } catch let error {
      alertFunction(self, title: LocalizableStrings.alert.localized, body: error.localizedDescription)
    }
              
  }
  
  func navigationSetup() {
    navigationController?.navigationBar.isHidden = true
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
}
