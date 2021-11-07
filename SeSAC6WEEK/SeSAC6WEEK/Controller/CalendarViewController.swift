//
//  CalendarViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var calendarTabBarItem: UITabBarItem! {
    didSet {
      calendarTabBarItem.title = LocalizableStrings.calendar.localized
    }
  }
  
  @IBOutlet weak var calendarView: FSCalendar! {
    didSet {
      calendarView.delegate = self
      calendarView.dataSource = self
    }
  }
  @IBOutlet weak var wholeDiaryCountLabel: UILabel!
  
  let localRealm = try! Realm()
  var tasks: Results<UserDiary>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = localRealm.objects(UserDiary.self)
    
    wholeDiaryCountLabel.text = "Total \(tasks.count)개의 기록이 있습니다."
    
    let sortedByWriteDate = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    
    let recent = sortedByWriteDate.first?.title
    wholeDiaryCountLabel.text?.write("\n가장 최근의 다이어리는\(recent ?? "")입니다.")
    let old = sortedByWriteDate.last?.title
    wholeDiaryCountLabel.text?.write("\n가장 오래된 다이어리는\(old ?? "")입니다.")
    
    
    
    #if DEBUG
      print(localRealm.configuration.fileURL)
    #endif
  }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
  }
  
//  func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//    "뿌에에에에ㅔ"
//  }
  
//  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//    "뿌에에에2"
//  }
  
//  func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//    UIImage(systemName: "person.circle.fill")
//  }
  
//  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//    return FSCalendarCell()
//  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    let diaryDates = tasks.filter("writeDate")
    return 1
  }
}
