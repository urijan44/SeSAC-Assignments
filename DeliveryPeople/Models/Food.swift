//
//  Food.swift
//  DeliveryPeople
//
//  Created by hoseung Lee on 2021/09/28.
//

import Foundation
import UIKit

struct Food {
  let name: String
  let imageName: String
  
  var image: UIImage {
    UIImage(named: imageName) ?? UIImage()
  }
}

class Foods {
  let catogries: [Food] = [
    Food(name: "랍스터", imageName: "mono_baedal01"),
    Food(name: "2인분", imageName: "mono_baedal02"),
    Food(name: "모노오더", imageName: "mono_baedal03"),
    Food(name: "한식", imageName: "mono_baedal04"),
    Food(name: "떡볶쓰", imageName: "mono_baedal05"),
    Food(name: "디저트", imageName: "mono_baedal06"),
    Food(name: "스시/초밥", imageName: "mono_baedal07"),
    Food(name: "치킨", imageName: "mono_baedal08"),
    Food(name: "피자", imageName: "mono_baedal09"),
    Food(name: "라면", imageName: "mono_baedal10"),
    Food(name: "중국집", imageName: "mono_baedal11"),
    Food(name: "족발", imageName: "mono_baedal12"),
    Food(name: "야식", imageName: "mono_baedal13"),
    Food(name: "탕/찌개", imageName: "mono_baedal14"),
    Food(name: "도시락", imageName: "mono_baedal15"),
    Food(name: "햄버거", imageName: "mono_baedal16"),
  ]
}
