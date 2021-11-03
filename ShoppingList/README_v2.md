# Shopping List

- 이전 [README.md](README_v2.md)

# Realm 적용하기
- 기존 모델과 모델 매니저를 Realm 데이터베이스 적용
- 데이터 추가, 삭제, 정렬 구현
- 역시 라이브러리를 써서 그런가 매니저를 적용하는 것 보다 훨씬 쉬운 것 같음


# Realm 모델
```Swift
import RealmSwift

class UserWish: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var wishDescription: String
  @Persisted var check: Bool
  @Persisted var star: Bool
  
  convenience init(wishDescription: String) {
    self.init()
    
    self.wishDescription = wishDescription
    self.check = false
    self.star = false
  }
}
```

# 모델 정렬
- 쇼핑리스트는 즐겨찾기, 체크, 이름순으로 정렬되는데 Results 모델을 참조하는 인스턴스를 하나 더 만들어서 사용
```Swift
  let localRealm = try! Realm()
  var tasks: Results<UserWish>!
  var sortedUserWishs: Results<UserWish>!

  @IBAction func sortByFavorite(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "star", ascending: false)
    UserDefaults.standard.set(SortStyle.favorite.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByCheck(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "check", ascending: false)
    UserDefaults.standard.set(SortStyle.check.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByName(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "wishDescription", ascending: true)
    UserDefaults.standard.set(SortStyle.name.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
```

# 체크, 즐겨찾기 반영
- Realm Model 인스턴스가 클래스 객체이다 보니, 참조로 전달 된 인스턴스를 변경하더라도 원본이 변경되어서 훨씬 또 쉽게 값을 바꿀 수 있었다.
```Swift
  @objc func toggleCheck(_ gesture: CheckGesture) {
    try! localRealm.write {
      gesture.wish?.check.toggle()
    }
    if let _ = gesture.indexPath {
      tableView.reloadData()
    }
  }
  
  @objc func toggleStar(_ gesture: StarGesture) {
    try! localRealm.write {
      gesture.wish?.star.toggle()
    }
    if let _ = gesture.indexPath {
      tableView.reloadData()
    }
  }
```
