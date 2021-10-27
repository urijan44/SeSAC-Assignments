//
//  ViewController.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentLocationLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.delegate = self
      collectionView.dataSource = self
      
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 44)
      
      collectionView.collectionViewLayout = layout
      
      collectionView.register(.init(nibName: LabelCell.identifier, bundle: nil), forCellWithReuseIdentifier: LabelCell.identifier)
      collectionView.register(.init(nibName: ImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
      
    }
  }
  
  var weatherData: [String] = [] {
    didSet {
      collectionView.reloadSections(.init(integer: 0))
    }
  }
  
  var userLocation: CLLocationCoordinate2D? = .init() {
    didSet {
      guard let userLocation = userLocation else {
        return
      }

      currentLocationLabel.text = LocationManager.shared.getLocationString(coordinate: userLocation)
    }
  }
  
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateLabel.text = Date().customFormatted
    locationManager.delegate = self
    updateWeather()
  }

  @IBAction func updateWeather() {
    locationManager.startUpdatingLocation()
    guard let userLocation = userLocation else {
      print("유저정보 얻을 수 없음")
      checkUserLocationServicesAuthorization()
      locationManager.requestWhenInUseAuthorization()
      return
    }
    
    WheatherManager.shared.fetchWeatherData(userLocation) { [unowned self] statusCode, json in
      switch statusCode {
      case 200:
        var tempWeatherData: [String] = []
        print("ok")
        let temp = json["main"]["temp"].double
        tempWeatherData.append("지금은 \(String(format: "%.1f", temp ?? 0))℃ 에요!")
        
        let humidity = json["main"]["humidity"]
        tempWeatherData.append("\(humidity)% 만큼 습해요!")
        
        let wind = json["wind"]
        tempWeatherData.append("\(wind["deg"]) 방향으로 \(wind["speed"])m/s의 속도로 바람이 불어요")
        
        let weather = json["weather"][0]
        
        tempWeatherData.append("https://openweathermap.org/img/wn/\(weather["icon"])@2x.png")
        tempWeatherData.append("행복한 하루 보내세요")
        weatherData.removeAll()
        weatherData = tempWeatherData
      case 400:
        print("clientError")
        print(json.stringValue)
      default:
        print("error")
        print(json.stringValue)
      }
    }
    
    dateLabel.text = Date().customFormatted
  }
  
  func showRequestLocationServiceAlert() {
    let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
    let goSetup = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
      if let appSettings = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
      }
    }
    let cancel = UIAlertAction(title: "취소", style: .default)
    requestLocationServiceAlert.addAction(cancel)
    requestLocationServiceAlert.addAction(goSetup)
    
    present(requestLocationServiceAlert, animated: true, completion: nil)
  }
  
  
}
//MARK: - TableView Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    weatherData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let description = weatherData[indexPath.item]
    if description.first == "h" {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { fatalError("")}
      cell.configure(imageURL: description)
      
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCell.identifier, for: indexPath) as? LabelCell else { fatalError("")}
      
      
      cell.configure(description: description)
      
      return cell
      
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let description = weatherData[indexPath.item]
    if description.first == "h" {
      return .init(width: UIScreen.main.bounds.width, height: 200)
    } else {
      return .init(width: UIScreen.main.bounds.width, height: 44)
    }
        
  }
}

//MARK: - CoreLocation Delegates

extension ViewController: CLLocationManagerDelegate {
  func checkUserLocationServicesAuthorization() {
    let authorizationStatus: CLAuthorizationStatus
    print(#function)
    if #available(iOS 14.0, *) {
      authorizationStatus = locationManager.authorizationStatus
    } else {
      authorizationStatus = CLLocationManager.authorizationStatus()
    }
    
    if CLLocationManager.locationServicesEnabled() {
      checkCurrentLocationAuthorization(authorizationStatus)
    } else {
      showRequestLocationServiceAlert()
    }
  }
  
  func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
    print(#function)
    switch authorizationStatus {
    case .notDetermined:
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    case .restricted, .denied:
      showRequestLocationServiceAlert()
    case .authorizedAlways:
      print("never be called this line")
    case .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    @unknown default:
      print("default case")
    }
    
    if #available(iOS 14.0, *) {
      let accurancyState = locationManager.accuracyAuthorization
      
      switch accurancyState {
      case .fullAccuracy:
        print("detail")
      case .reducedAccuracy:
        print("reduced")
      @unknown default:
        fatalError("never be called this line!")
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("didUpdate")
    if let location = locations.last {
      userLocation = location.coordinate
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkUserLocationServicesAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkUserLocationServicesAuthorization()
  }
  
  
  
}
