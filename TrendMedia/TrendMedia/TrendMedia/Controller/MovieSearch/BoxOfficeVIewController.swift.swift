//
//  BoxOfficeVIewController.swift.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


class BoxOfficeViewController: UIViewController {
  
  @IBOutlet weak var searchField: UITextField! {
    didSet {
      searchField.delegate = self
    }
  }
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.register(.init(nibName: Constants.Cells.boxOfficeCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.boxOfficeCell)
      
      tableView.allowsSelection = true
    }
  }
  @IBOutlet weak var searchButton: UIButton! {
    didSet {
      searchButton.layer.shadowOpacity = 0.4
      searchButton.layer.shadowRadius = 1
      searchButton.layer.shadowOffset = . init(width: 1, height: 1)
      searchButton.layer.cornerRadius = 8
      searchButton.backgroundColor = .white
    }
  }
  
  let dateFormaatter = DateFormatter()
  let yesterday = Date(timeIntervalSinceNow: -(60 * 60 * 24))
  let localRealm = try! Realm()
  var boxOfficeHistory: Results<BoxOfficeHistory>!
  var dayBoxOffice: [BoxOfficeModel] = [] {
    didSet {
      tableView.reloadSections(.init(integer: 0), with: .automatic)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleSetup()
    
    boxOfficeHistory = localRealm.objects(BoxOfficeHistory.self)
    searchBoxOffice()
  }
  
  func titleSetup() {
    title = "일간 박스오피스"
    dateFormaatter.dateFormat = "yyyyMMdd"
    
    searchField.text = dateFormaatter.string(from: yesterday)
  }
  
  
  @IBAction func searchBoxOffice() {
    if let date = dateFormaatter.date(from: searchField.text ?? "") {
      let stringDate = dateFormaatter.string(from: date)
      let searchDate = boxOfficeHistory.filter("targetDate = %@", stringDate)
      
      if searchDate.isEmpty {
        fetchBoxOfficeDate(queryDate: stringDate) { [weak self] code, json in
          guard let self = self else { return }
          switch code {
          case 200:
            var tempDayBoxOffice: [BoxOfficeModel] = []
            
            json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.forEach { boxOffice in
              let movie = BoxOfficeModel(rank: boxOffice["rank"].stringValue,
                                         title: boxOffice["movieNm"].stringValue,
                                         pubDate: boxOffice["openDt"].stringValue.count < 10
                                         ? "미개봉"
                                         : boxOffice["openDt"].stringValue)
              tempDayBoxOffice.append(movie)
            }
            DispatchQueue.main.async {
              try! self.localRealm.write {
                let history: BoxOfficeHistory = .init(targetDate: stringDate, boxOfficeModels: tempDayBoxOffice)
                self.localRealm.add(history)
              }
              self.dayBoxOffice = self.boxOfficeHistory.filter("targetDate = %@", stringDate)[0].boxOfficeModels.map{$0}
            }
          default:
            print(code, json)
          }
        }
      } else {
        dayBoxOffice = boxOfficeHistory.filter("targetDate = %@", stringDate)[0].boxOfficeModels.map{$0}
      }
    } else {
      print("alert yyyyMMdd!!")
    }
  }
}

//MARK: - TableView DataSource, Delegate
extension BoxOfficeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dayBoxOffice.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.boxOfficeCell, for: indexPath) as? BoxOfficeCell
    else { fatalError("BoxOfficeCell load failure")}
    
    let movie = dayBoxOffice[indexPath.row]
    
    cell.configure(movie: movie)
    
    return cell
  }
}

extension BoxOfficeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    55
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    indexPath
  }
}

//MARK: - TextField Delegate
extension BoxOfficeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    searchBoxOffice()
    
    return true
  }
}

//MARK: - Data Request
extension BoxOfficeViewController {
  func getURL(date: String) -> URL? {
    var urlComponents = URLComponents(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")
    
    guard let bundleKey = Bundle.main.infoDictionary?["KobisKey"] as? String else { fatalError("key is nil")}
    
    let key: URLQueryItem = .init(name: "key", value: bundleKey)
    let date:  URLQueryItem = .init(name: "targetDt", value: searchField.text!)
    
    urlComponents?.queryItems = [key, date]
    
    return urlComponents?.url
  }
  
  func fetchBoxOfficeDate(queryDate: String, completion: @escaping (Int, JSON) -> Void) {
    guard let url = getURL(date: queryDate) else {fatalError("URL Build Failure")}
    AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { response in
      switch response.result {
      case .success(let value):
        let code = response.response?.statusCode ?? 500
        completion(code, JSON(value))
      case .failure(let error):
        print(error)
      }
    }
  }
}
