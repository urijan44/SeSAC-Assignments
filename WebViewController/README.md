# WebViewController

# WebView Button 구현
```Swift
  @IBAction func stopSearchButton() {
    if webView.isLoading {
      webView.stopLoading()
    }
  }
  
  @IBAction func goPreviousPage() {
    if webView.canGoBack {
      webView.goBack()
      getCurrentURLstring()
    }
  }
  
  @IBAction func goNextPage() {
    if webView.canGoForward {
      webView.goForward()
      getCurrentURLstring()
    }
  }
  
  @IBAction func refreshPage() {
    webView.reload()
  }
```
- 처음에 이런 기능 있는 줄 모르고 직접 구현하고 앉아있었다.
- 이전페이지 다음페이지 이동할 때 이동된 주소가 주소창에 반영되도록 `getCurrentURLstring()`메소드를 추가했다.
-

```Swfit
  var currentURL: String = "https://www.google.com" {
    didSet {
      urlSearchBar.text = currentURL
    }
  }
```
- `currentURL`이 변경되면 자동으로 urlSearchBar 내용이 바뀐다.

```Swift
    var urlString = searchBar.text ?? ""
    if !urlString.hasPrefix("https://") {
      urlString = "https://" + urlString
    }
<!--    urlString = urlString.lowercased()-->
    
    requestURL(urlString: urlString)
```
- url 요청시 https 가 빠져있으면 넣도록 했다.
- 대문자를 입력하면 자동으로 소문자로 바꾸어 주는걸 넣었는데 생각해보니 대문자가 들어갈 수도 있다.

