import Foundation
struct ExchangeRate {
  var currencyRate: Double {
    willSet {
      print("기존 환율 USD 1 : KRW \(currencyRate) -> USD 1 : KRW \(newValue) 으로 환율 변동 예정입니다.")
    }
    
    didSet {
      print("기존 환율 USD 1 : KRW \(oldValue) -> USD 1 : KRW \(currencyRate) 으로 환율 확정되었습니다.")
    }
  }
  
  private var totalUSD: Double = 0
  
  var exchangedUSD: Double {
    krw / currencyRate
  }
  
  var krw: Double = 0 {
    willSet {
      print("KRW \(String(format: "%.0f", newValue)) -> USD \(String(format: "%.2f", newValue / currencyRate)) 환전 예정")
    }
    
    didSet {
      print(("KRW \(String(format: "%.0f", krw)) -> USD \(String(format: "%.2f", exchangedUSD)) 환전 되었습니다 "))
      usd += exchangedUSD
    }
  }
  
  private(set) var usd: Double {
    get {
      return totalUSD
    }
    set {
      totalUSD += newValue
    }
  }
  
  init(currencyRate: Double) {
    self.currencyRate = currencyRate
  }
  
  
}

var rate = ExchangeRate(currencyRate: 1200)
rate.currencyRate = 1300
rate.krw = 500_000
print("현재 달러 잔고 \(String(format: "%.2f", rate.usd))")
rate.krw = 100_000
print("현재 달러 잔고 \(String(format: "%.2f", rate.usd))")
