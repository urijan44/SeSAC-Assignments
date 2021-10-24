//
//  MapViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  
  let manager = TheaterLocationManager()
  
  //서울 시청을 기본 좌표로 함
  let defaultLocation = CLLocationCoordinate2D(latitude: 37.566667, longitude: 126.978368)
  
  var userLocation: CLLocationCoordinate2D? {
    didSet {
      //annotation update
      if let userLocation = userLocation {
        mapView.removeAnnotation(userAnnotation)
        userAnnotation.coordinate = userLocation
        userAnnotation.title = "지금 위치"
        mapView.addAnnotation(userAnnotation)
      }
      
      
      //reverse geocoding
      if let userLocation = userLocation {
        geocoder.reverseGeocodeLocation(.init(latitude: userLocation.latitude, longitude: userLocation.longitude)) { placemarks, error in
          if error == nil, let places = placemarks, !places.isEmpty {
            self.placemark = places.last!
          } else {
            self.placemark = nil
          }
        }
        if let placemark = placemark {
          let address = "\(placemark.country?.description ?? "") \(placemark.locality?.description ?? "") \(placemark.subLocality?.description ?? "")"
          title = address
        }
      }
      
    }
  }
  
  let locationManager = CLLocationManager()
  let geocoder = CLGeocoder()
  var placemark: CLPlacemark?
  var locationTraceState = false {
    didSet {
      if locationTraceState {
        locationManager.startUpdatingLocation()
        userLocationButton.tintColor = .blue
      } else {
        locationManager.stopUpdatingLocation()
        userLocationButton.tintColor = .gray
      }
    }
  }
  var theatersAnnotations: [MKPointAnnotation] = [] {
    didSet {
      region()
    }
  }
  var userAnnotation = MKPointAnnotation() {
    didSet {
      region()
    }
  }
  
  @IBOutlet weak var filterButton: UIBarButtonItem! {
    didSet {
      filterButton.tintColor = .blue
    }
  }
  @IBOutlet weak var mapView: MKMapView! {
    didSet {
      mapView.delegate = self
    }
  }
  
  @IBOutlet weak var userLocationButton: UIButton! {
    didSet {
      userLocationButton.layer.cornerRadius = 8
      userLocationButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
      userLocationButton.layer.shadowOffset = .init(width: 1, height: 1)
      userLocationButton.layer.shadowRadius = 2
      userLocationButton.layer.shadowOpacity = 0.4
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    
    if userLocation == nil {
      let region = MKCoordinateRegion(center: defaultLocation, latitudinalMeters: 50, longitudinalMeters: 50)
      mapView.setRegion(region, animated: true)
    }
    
    locationManager.delegate = self
    showWholeTheatersAnnotations()
  }
  
  func showWholeTheatersAnnotations() {
    let whole = manager.theaters
    whole.forEach { theater in
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
      annotation.title = "\(theater.brand) \(theater.dong)점"
      theatersAnnotations.append(annotation)
    }
    mapView.addAnnotations(self.theatersAnnotations)
  }
  
  func region() {
    guard let userLocation = userLocation else {
      return
    }

    if locationTraceState {
      
      let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 100, longitudinalMeters: 100)
      mapView.setRegion(region, animated: true)
    } else {
      let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
      mapView.setRegion(region, animated: true)
    }
  }
  
  @IBAction func filterCinemaPlace(_ sender: UIBarButtonItem) {
    let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
      self.locationManager.stopUpdatingLocation()
      
      self.mapView.removeAnnotations(self.theatersAnnotations)
      self.theatersAnnotations.removeAll()
      let megaboxes = self.manager.megaboxTheaters
      megaboxes.forEach { theater in
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
        annotation.title = "\(theater.brand) \(theater.dong)점"
        self.theatersAnnotations.append(annotation)
      }
      self.mapView.addAnnotations(self.theatersAnnotations)
    }
    
    let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
      self.locationManager.stopUpdatingLocation()
      
      self.mapView.removeAnnotations(self.theatersAnnotations)
      self.theatersAnnotations.removeAll()
      let lottes = self.manager.lotteTheaters
      lottes.forEach { theater in
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
        annotation.title = "\(theater.brand) \(theater.dong)점"
        self.theatersAnnotations.append(annotation)
      }
      self.mapView.addAnnotations(self.theatersAnnotations)
    }
    
    let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
      self.locationManager.stopUpdatingLocation()
      
      self.mapView.removeAnnotations(self.theatersAnnotations)
      self.theatersAnnotations.removeAll()
      let cgvs = self.manager.cgvTheaters
      cgvs.forEach { theater in
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
        annotation.title = "\(theater.brand) \(theater.dong)점"
        self.theatersAnnotations.append(annotation)
      }
      self.mapView.addAnnotations(self.theatersAnnotations)
    }
    
    let filterFree = UIAlertAction(title: "전체보기", style: .default) { _ in
      self.locationManager.stopUpdatingLocation()
      
      self.mapView.removeAnnotations(self.theatersAnnotations)
      self.theatersAnnotations.removeAll()
      self.showWholeTheatersAnnotations()
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    [megabox, lotte, cgv, filterFree, cancel].forEach { action in
      actionAlert.addAction(action)
    }
    
    present(actionAlert, animated: true, completion: nil)
    
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
  
  
  @IBAction func showCurrentUserLocation() {
    if CLLocationManager.locationServicesEnabled() {
      let authorizationStatus: CLAuthorizationStatus
        
      if #available(iOS 14.0, *) {
        authorizationStatus = locationManager.authorizationStatus
      } else {
        authorizationStatus = CLLocationManager.authorizationStatus()
      }
      
      if authorizationStatus == .authorizedWhenInUse {
        locationTraceState.toggle()
      } else {
        checkUserLocationServicesAuthrization()
      }
      
    } else {
      checkUserLocationServicesAuthrization()
      return
    }

    
    
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func checkUserLocationServicesAuthrization() {
    let authorizationStatus: CLAuthorizationStatus
      
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
        print("detail is false")
      case .reducedAccuracy:
        print("Reduced")
      @unknown default:
        fatalError("never be called thie line!")
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      
      mapView.setRegion(.init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
      userLocation = location.coordinate
      
      if locations.count > 20, locations.first == locations.last {
        locationManager.stopUpdatingLocation()
      }
      
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkUserLocationServicesAuthrization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkUserLocationServicesAuthrization()
  }
  
}

extension MapViewController: MKMapViewDelegate {
  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    locationTraceState = false
  }
}
