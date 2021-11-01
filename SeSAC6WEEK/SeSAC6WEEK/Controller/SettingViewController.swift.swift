//
//  SettingViewController.swift.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class SettingViewController: UIViewController {
  
  @IBOutlet weak var settingTabBarItem: UITabBarItem! {
    didSet {
      settingTabBarItem.title = LocalizableStrings.setting.localized
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
