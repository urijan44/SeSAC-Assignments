# Trend Media 1029

[1017 버전 README](1017README.md)<br>
[1018 버전 README](1018README.md)<br>
[1019 버전 README](1019README.md)<br>
[1020 버전 README](1020README.md)<br>
[1027 버전 README](1027README.md)<br>
[1028 버전 README](1028README.md)<br>

## 변경점
### 1. 미디어 디테일 뷰 데이터 패치 구현
![](src/ActorDetailView.png)
Cast,Crew 섹션별로 표시

Cast, Crew 같은 데이터를 가지고 있으므로 Cast 모델로 묶어서 처리

### 2. 웹 뷰를 통해 미디어 트레일러 재생
![](src/webview.gif)

# ...
- Cast, Crew 스크롤이 너무 긴데, 세그먼트 컨트롤 같은걸로 누르면 바로 해당 스크롤로 이동했으면 좋겠다.

- 네트워크 요청에 대한 스테이터스 코드 상태 처리 할 필요 있음