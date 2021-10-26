//
//  BoxOfficeVIewController.swift.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

struct BoxOfficeModel: Decodable {
  let rank: String
  let title: String
  let pubDate: String
}


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
  
  var dayBoxOffice: [BoxOfficeModel]  = [] {
    didSet {
      tableView.reloadSections(.init(integer: 0), with: .automatic)
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "일간 박스오피스"
    dateFormaatter.dateFormat = "yyyyMMdd"
    let yesterday = Date(timeIntervalSinceNow: -(60 * 60 * 24))
    searchField.text = dateFormaatter.string(from: yesterday)
    searchBoxOffice()
  }
  
  
  @IBAction func searchBoxOffice() {
    if let date = dateFormaatter.date(from: searchField.text ?? "") {
      let stringDate = dateFormaatter.string(from: date)
      fetchBoxOfficeDate(queryDate: stringDate)
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
  
  func fetchBoxOfficeDate(queryDate: String) {
    guard let url = getURL(date: queryDate) else {fatalError("URL Build Failure")}
    
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print(error.localizedDescription)
      }
      if let data = data, let response = response {
        if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 200 {
            let json = JSON(data)
            
            var tempDayBoxOffice: [BoxOfficeModel] = []
            
            json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.forEach { receive in
              let moive = BoxOfficeModel(rank: receive["rank"].stringValue,
                                         title: receive["movieNm"].stringValue,
                                         pubDate: receive["openDt"].stringValue.count < 10 ? "미개봉" : receive["openDt"].stringValue)
              tempDayBoxOffice.append(moive)
            }
            
            DispatchQueue.main.async {
              self.dayBoxOffice = tempDayBoxOffice
            }
          }
        }
      }
    }.resume()
  }
  
}
