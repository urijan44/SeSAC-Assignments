//
//  LottoViewModel.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//

import Foundation
class LottoViewModel {
  
  var numbers: [Observable<Int>] = [Observable(3),
                        Observable(10),
                        Observable(33),
                        Observable(23),
                        Observable(12),
                        Observable(42),
                        Observable(45)]
  var date = Observable("")
  var lottoMoney = Observable(0)
  
  func fetchLottoAPI(number: Int, completion: @escaping (Lotto?, APIError?) -> Void) {
    APIService.lotto(number: number) { lotto, error in
      guard let lotto = lotto else {
        completion(nil, error)
        return
      }
      self.numbers[0].value = lotto.drwtNo1
      self.numbers[1].value = lotto.drwtNo2
      self.numbers[2].value = lotto.drwtNo3
      self.numbers[3].value = lotto.drwtNo4
      self.numbers[4].value = lotto.drwtNo5
      self.numbers[5].value = lotto.drwtNo6
      self.numbers[6].value = lotto.bnusNo
      self.lottoMoney.value = lotto.firstAccumamnt
      self.date.value = lotto.drwNoDate
      

    }
  }
}

extension Int {
  var decimalNumber: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: self as NSNumber)!
  }
}
