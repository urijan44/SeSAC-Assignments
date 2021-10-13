# 환율 변동 프로그램

1. CurrenyRate와 krw은 값 변동시 변동 정보에 대해 알려준다.
2. krw값 변동시 usd잔고를 exchangedUSD 계산 프로퍼티를 통해 증가 시킨다.
3. usd는 setter는 private 속성으로 외부에서 임의로 값을 변동시킬 수 없다.
4. usd getter는 총 환전한 totalUSD를 리턴한다.
