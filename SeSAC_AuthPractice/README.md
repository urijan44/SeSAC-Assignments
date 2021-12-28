# 회원가입 구현하기
# 보드 구현

- skeletion 
![](src/3.gif)
- skeletion View가 뭔가 마음대로 안된다.

- API 호출에서 URLSession 클로져 반복되는 부분을 메소드로 따로 빼보았다.
```Swift
static func fetchBoard(token: String, boardType: BoardElement, completion: @escaping (BoardElement?, APIError?) -> Void) {
    let url = URL(string: "http://test.monocoding.com/boards")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    
    requestTask(request: request, objectType: boardType) { board, error in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        if let _ = error {
          completion(nil, error)
          return
        }
        
        if let board = board {
          completion(board, nil)
          return
        }
      }
    }
  }
  
  fileprivate static func requestTask<T: Decodable>(request: URLRequest, objectType: T, completion: @escaping (T?, APIError?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(nil, .failed)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil, .invalidResponse)
        return
      }
      
      guard let data = data else {
        completion(nil, .noData)
        return
      }

      guard let decoded = try? JSONDecoder().decode([T].self, from: data) else {
        completion(nil, .invalidData)
        return
      }
      completion(decoded.first, nil)
    }
    task.resume()
  }
```