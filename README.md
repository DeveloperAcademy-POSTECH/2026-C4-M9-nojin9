# Nojin9

언니들의 옷장을 함께 공유하고, 필요한 옷을 포인트로 빌려 입을 수 있는 옷장 공유 iOS 앱입니다.

대여부터 반납, 감사 편지 작성까지 하나의 흐름으로 연결해 빌리는 경험을 더 따뜻하고 부담 없이 만드는 것을 목표로 합니다.

## 팀 프로필


| 이름 | 역할 | 소개 | Website | Instagram | LinkedIn | GitHub |
| --- | --- | --- | --- | --- | --- | --- |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |


## 핵심 기능

### 공유 옷장 둘러보기

- 내 옷장과 친구/언니의 옷장을 구분해서 볼 수 있습니다.
- 상의, 하의, 기타 카테고리로 옷을 탐색할 수 있습니다.
- 옷 상세 화면에서 대여 비용, 설명, 상태 정보를 확인할 수 있습니다.

### 옷 등록하기

- 카메라 또는 사진을 활용해 새 옷을 등록할 수 있습니다.
- Vision 기반 누끼 처리 흐름을 통해 옷 이미지를 더 깔끔하게 보여주는 실험을 포함합니다.
- 카테고리별 기본 포인트 비용을 바탕으로 공유 옷장에 올릴 수 있습니다.

### 대여하기

- 빌리고 싶은 옷을 선택하고 대여 기간을 설정할 수 있습니다.
- 포인트를 사용해 대여 흐름을 완료합니다.
- 대여 완료 후 영수증/완료 화면으로 이어집니다.

### 반납하기

- 현재 빌린 옷과 반납 기한을 확인할 수 있습니다.
- 반납할 물건의 훼손 여부를 기록할 수 있습니다.
- 반납 흐름에서 바로 감사 편지 작성 화면으로 이동할 수 있습니다.

### 감사 편지 작성하기

- 반납한 옷 또는 대여한 옷에 대해 감사 편지를 남길 수 있습니다.
- 사진과 후기를 함께 등록해 빌려준 사람에게 고마움을 표현합니다.
- 받은 감사 편지는 홈과 감사 편지 목록에서 확인할 수 있습니다.

## 주요 사용자 흐름

```text
온보딩
  -> 홈
  -> 공유 옷장 탐색
  -> 옷 상세 확인
  -> 대여 신청
  -> 대여 완료
  -> 반납하기
  -> 감사 편지 작성
  -> 받은 감사 편지 확인
```

## 화면 구성

| 영역 | 설명 |
| --- | --- |
| Onboarding | 서비스 소개, 초대/관계 설정 흐름 |
| Home | 내 옷장, 공유 옷장, 받은 감사 편지, 주요 진입점 |
| My Closet | 내가 등록한 옷과 전체 옷장 보기 |
| Rental | 옷 상세, 대여 신청, 대여 완료 |
| Return | 빌린 옷 반납, 훼손 여부 기록, 편지 작성 진입 |
| Review | 감사 편지 목록, 작성 대상 선택, 편지 작성, 편지 상세 |
| Upload | 옷 등록, 사진 선택/촬영, 색상 및 설명 입력 |

## 기술 스택

| 분류 | 사용 기술 |
| --- | --- |
| Platform | iOS |
| Language | Swift |

## 프로젝트 구조

```text
Nojin9/
  App/
    Nojin9App.swift
  Core/
    ToolbarMode.swift
  Data/
    AppDataModels.swift
    AppDataStore.swift
    MockData.swift
  Features/
    Home/
    MyCloset/
    Rental/
    Return/
    Review/
    Upload/
    Onboarding/
    ClothCutout/
    DesignSystem/
```
