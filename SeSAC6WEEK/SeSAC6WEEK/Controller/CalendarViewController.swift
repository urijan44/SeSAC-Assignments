//
//  CalendarViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var calendarTabBarItem: UITabBarItem! {
    didSet {
      calendarTabBarItem.title = LocalizableStrings.calendar.localized
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
}
