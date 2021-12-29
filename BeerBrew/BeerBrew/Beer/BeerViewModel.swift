//
//  BeerViewModel.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/30.
//

import Foundation

class BeerViewModel {
  var beer: Observable<Beer> = Observable(Beer(name: "", origin: "", description: "", imageURL: nil, foodPairing: []))
  
  var foodPairing: [String] {
    beer.value.foodPairing
  }
  
  var foodPairingCount: Int {
    beer.value.foodPairingCount
  }
  
  
  
  func fetchBeer(_ completion: @escaping (URL?, Bool) -> Void) {
    BeerManager.shared.fetchBeer { beer in
      DispatchQueue.main.async {
        if let beer = beer {
          self.beer.value = beer
          let url = URL(string: beer.imageURL ?? "")
          completion(url, true)
        }
      }
    }
  }
}
