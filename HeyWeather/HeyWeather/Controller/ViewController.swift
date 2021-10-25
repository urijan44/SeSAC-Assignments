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
  
  let weatherManager = WheatherManager()
  
  var weatherData: [String] = [] {
    didSet {
      collectionView.reloadData()
      
    }
  }
  
  let locationManager = LocationManager.shared.locationManager
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateLabel.text = Date().customFormatted
    locationManager.delegate = self
    updateWeather()
  }

  @IBAction func updateWeather() {
    locationManager.startUpdatingLocation()
    guard let userLocation = LocationManager.shared.userLocation else {
      print("유저정보 얻을 수 없음")
      checkUserLocationServicesAuthorization()
      locationManager.requestWhenInUseAuthorization()
      return
    }
    currentLocationLabel.text = LocationManager.shared.hcodeAddress
    weatherManager.fetchWeatherData(userLocation)
    collectionView.reloadSections(.init(integer: 0))
    weatherData = weatherManager.weatherData
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
    weatherManager.weatherData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let description = weatherManager.weatherData[indexPath.item]
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
    let description = weatherManager.weatherData[indexPath.item]
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
      LocationManager.shared.userLocation = location.coordinate
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkUserLocationServicesAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkUserLocationServicesAuthorization()
  }
  
  
  
}
