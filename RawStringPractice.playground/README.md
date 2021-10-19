# Swift5 Raw String
Raw String은 Swift 에서 문자열 표현 방법으로 기존 쌍따옴표 안에서 예약된 특수 문자를 표현하기 위해서는 아래와 같이 썼다.
```Swift
let greeting = "Hello My name is \"Henry\"!"
```
간단한 문자나 예에서는 크게 어려워 보이지는 않지만 정규표현식과 함께한다면 지옥을 볼수도 있다.
```Swift
let regex = try NSRegularExpression(pattern: "\\\\\\([^)]+\\)")
```

위 정규표현식을 Raw String으로 표현한다면 아래와 같다.

```Swift
let regex = try NSRegularExpression(pattern: #"\\\([^)]+\)"#)
```
구분하기 위한 슬래시가 덧붙어 있지 않가 가독성이 늘어난다.

앞서 작성했던 인사말도 이렇게 작성할 수 있다.
```Swift
let greeting = #"Hello My name is "Henry"!"#
```
#의 개수는 몇개든 상관없이 open과 close에서 숫자만 동일하면 된다.

한가지 주의할점은 string interpolation같은 경우도 무시될 수 있다는 것이다.

```Swift
let name = "Memil"
let greeting = #"Hello My name is "\(name)"!"#
//Hello My name is "\(name)"!
```

Raw String안에서 예약 문자를 사용하기 위해서는 다시한번 #을 붙여줄 수 있다.
```Swift
let name = "Memil"
let greeting = #"Hello My name is "\#(name)"!"#

//Hello My name is "Memil"!
```