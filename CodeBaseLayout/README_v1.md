# 코드 기반 레이아웃 

- Melon, Kakao, 배민 중 Melon만 90% 완료

# Melon
![](src/melon.PNG)
- 밑에 플레이 컨트롤은 구현 안함 (시간부족)
- addTarget으로 추가한 버튼 액션이 자꾸 안되어서 (시뮬레이터 버그 같은데), 시간 낭비 많이함

- 노래 제목앞에 음표 마크랑 제목 레이블이 합쳐서 센터 정렬이 된거 같아서 NSAttributedString에다 NSTextAttachment 써서 이미지를 붙여버림
```Swift
    let titleAttr = NSMutableAttributedString(string: "strawberry moon")
    let titleAttech = NSTextAttachment(image: UIImage(systemName: "music.note")!.withTintColor(.secondaryWhiteColor))
```

- 노래 가사부분은 텍스트 뷰 인거 같은데, 텍스트 뷰 세부 설정을 위해 paragraphStyle과 attributed속성 활용
- 스크롤 뷰이지만 나오는 가사에 맞게 스크롤이 자동으로 딱딱 맞게 이동하는데, scrollRangeToVisiable를 사용, 실제로 재생시 맞춰서 인덱스만 이동시켜주면 될듯
```Swift
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 4
    style.alignment = .center
    let attr = [NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                NSAttributedString.Key.foregroundColor: UIColor.secondaryWhiteColor]
    
    lyricView.attributedText = NSAttributedString(string: lyric, attributes: attr)
    
    let arrLy = lyric.components(separatedBy: "\n").filter{!$0.isEmpty}
    let range = (lyric as NSString).range(of: arrLy[0])
    lyricView.scrollRangeToVisible(range)
```

# ...
아 코드로 하니까 진짜 오래 걸린다.