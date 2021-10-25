//
//  LocationManager.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import CoreLocation

class LocationManager {
  
  static let shared = LocationManager()
  
  let locationManager = CLLocationManager()
  let geocoder = CLGeocoder()
  var userLocation: CLLocationCoordinate2D?
  var placemark: CLPlacemark?
  
  var hcodeAddress: String {
    if let userLocation = userLocation {
      geocoder.reverseGeocodeLocation(.init(latitude: userLocation.latitude, longitude: userLocation.longitude), preferredLocale: .init(identifier: "ko-KR")) { placemarks, error in
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
    }
    return "Nowhere"
  }
}
