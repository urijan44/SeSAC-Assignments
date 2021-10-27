//
//  LocationManager.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import CoreLocation

class LocationManager {
  
  static let shared = LocationManager()
  
  private init() {}
  
  let locationManager = CLLocationManager()
  let geocoder = CLGeocoder()
  var userLocation: CLLocationCoordinate2D?
  var placemark: CLPlacemark?
  
  func getLocationString(coordinate: CLLocationCoordinate2D) -> String {
    geocoder.reverseGeocodeLocation(.init(latitude: coordinate.latitude, longitude: coordinate.longitude), preferredLocale: .init(identifier: "ko-KR")) { placemarks, error in
      if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
        self.placemark = placemarks.last
      } else {
        self.placemark = nil
      }
    }
    if let placemark = placemark {
      let address = "\(placemark.administrativeArea?.description ?? ""), \(placemark.subLocality?.description ?? "")"
      return address
    }
    return "Nowhere"
  }
}
