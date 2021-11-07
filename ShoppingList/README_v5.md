# Shopping List 

- [README_v1.md](README_v1.md)
- [README_v2.md](README_v2.md)
- [README_v3.md](README_v3.md)
- [README_v4.md](README_v4.md)


# 추가 구현 기능
- 복구 시 앱 리부트 없이 변경된 Realm 데이터 적용


# 앱 리부트 없는 Realm 복구
- Realm 파일 자체를 교체하게 되면, 앱의 루트 뷰 컨트롤러를 재 설정 하더라고 어쨌거나 Realm에서 충돌이 일어나서 앱이 꺼지게 된다.
- Realm 문서 탐방 중 계정 인증? 관련해서 Realm 데이터를 복구 하는 예제를 찾을 수 있었다.
[Performing a Client Reset with Swift by "pmanna-tse-realm"](https://github.com/mongodb/realm-practice/tree/main/swift)

- 순서는 아래와 같다.
1. 백업할 archive.zip 을 App Document Directory로 가져온다. 이 때 끝나고 파일들을 삭제할 것이기 때문에 temp, backup 따위의 이름으로 별도 디렉토리에 가져온다.
2. zip decomporessed
3. 원본 realm 인스턴스 생성
4. 가져온 백업 realm 인스턴스 생성
5. 백업 realm의 Category 오브젝트를 순회하면서 원본 realm에 create 한다. (결국 덮어쓰는 작업)
6. 백업 archive 삭제

요 순으로 하면 기존 realm파일을 통째로 교체해서 앱 종료 없이 데이터를 복구할 수 있다.

## 1 ~ 2
```Swift
do {
      try FileManager.default.createDirectory(
        at: Constants.backupPath,
        withIntermediateDirectories: true,
        attributes: nil)
      try FileManager.default.copyItem(at: selectedUrl, to: archivePath)
      try Zip.unzipFile(archivePath, destination: Constants.backupPath, overwrite: true, password: "1234", progress: { progress in
        print(progress)
        //progress hud view
      }, fileOutputHandler: { unzippedFile in

      })
```
- Document 디렉토리에 별도 백업 디렉토리를 만들고 그 안에 백업 파일을 둔다.

## 3 ~ 4
```Swift
      let realm = try! Realm()
      let backupRealmURL = Constants.backupPath.appendingPathComponent("default").appendingPathExtension("realm")
      guard FileManager.default.fileExists(atPath: backupRealmURL.path) else {
        showAlert(self, title: "알림", body: "백업 파일 위치를 찾을 수 없습니다", onlyOk: true, handler: nil)
        try? FileManager.default.removeItem(at: Constants.backupPath)
        return
      }
      
      let config = Realm.Configuration(fileURL: backupRealmURL, readOnly: true)
      guard let backupRealm = try? Realm(configuration: config) else{
        showAlert(self, title: "알림", body: "복구에 실패했습니다.", onlyOk: true, handler: nil)
        try? FileManager.default.removeItem(at: Constants.backupPath)
        return
      }
      
      let backupCategory = backupRealm.objects(Category.self)
```
- 백업용 realm과 원본 realm 인스턴스 생성


## 5 ~ 6

```Swift
      do {
        try realm.write {
          for category in backupCategory {
            realm.create(Category.self, value: category, update: .modified)
          }
        }
      } catch let error {
        showAlert(self, title: "알림", body: error.localizedDescription, onlyOk: true, handler: nil)
      }
      
      try FileManager.default.removeItem(at: archivePath)
      try FileManager.default.removeItem(at: Constants.backupPath)
      
      showAlert(self, title: "알림", body: "백업 파일을 불러왔습니다\n", onlyOk: true) { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popToRootViewController(animated: true)
      }
```
- 원본 realm에 백업 realm을 덮어쓴다.
- 작업이 끝나면 백업 파일 및 디렉토리는 삭제
- 선택이지만 복구가 성공적으로 끝나면 root view로 돌려주는 게 좋다.

