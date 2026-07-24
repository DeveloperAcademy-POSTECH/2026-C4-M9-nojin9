# Nojin9

언니들의 옷장을 함께 공유하고, 필요한 옷을 포인트로 빌려 입을 수 있는 옷장 공유 iOS 앱입니다.

대여부터 반납, 감사 편지 작성까지 하나의 흐름으로 연결해 빌리는 경험을 더 따뜻하고 부담 없이 만드는 것을 목표로 합니다.

> Apple Developer Academy Challenge 4에서 제작한 MVP 프로젝트입니다.

## 프로젝트 배경

가까운 사이에서도 옷을 빌리고 돌려주는 과정은 생각보다 번거롭습니다.

누가 어떤 옷을 가지고 있는지, 언제까지 돌려줘야 하는지, 빌린 뒤 고마움을 어떻게 표현할지까지 모두 따로 관리해야 하기 때문입니다.

Nojin9는 지인 간 옷 공유를 더 명확하고 즐겁게 만들기 위해 다음 질문에서 출발했습니다.

- 옷장을 공유하면 서로의 선택지가 더 넓어질 수 있을까?
- 대여와 반납 흐름을 앱 안에서 자연스럽게 관리할 수 있을까?
- 빌려 입은 경험이 감사 편지와 후기로 이어질 수 있을까?

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
| UI | SwiftUI |
| Data | In-memory mock data store |
| Image | PhotosUI, Vision 기반 cloth cutout 실험 |
| Navigation | NavigationStack |
| Minimum Target | iOS 18.6 |

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

## 개발 기록 요약

이 프로젝트는 MVP 완성도를 높이기 위해 화면 연결, 네비게이션 안정화, 옷 이미지 처리, 대여/반납/감사 편지 플로우를 반복적으로 개선했습니다.

- 홈 화면에서 내 옷장/공유 옷장/감사 편지 진입 흐름 정리
- 마이페이지와 반납 화면의 주요 navigation 연결
- 감사 편지 작성 플로우의 native NavigationStack 뒤로가기 정리
- 반납 화면에서 해당 옷의 감사 편지 작성 화면으로 바로 이동하는 흐름 추가
- 옷 누끼 처리와 이미지 표시 품질 개선
- 온보딩 화면과 뒤로가기 UX 정리

## 팀 프로필

각 팀원의 공개 프로필과 포트폴리오 링크를 정리하는 공간입니다.

외부 방문자가 팀원의 작업과 관심사를 더 쉽게 확인할 수 있도록 자유롭게 채워 주세요.

| 이름 | 역할 | 소개 | Website | Instagram | LinkedIn | GitHub |
| --- | --- | --- | --- | --- | --- | --- |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |
| 이름을 입력하세요 | PM / Design / iOS / etc. | 한 줄 소개를 입력하세요 | [Website](#) | [Instagram](#) | [LinkedIn](#) | [GitHub](#) |

## 실행 방법

1. 이 저장소를 clone합니다.
2. `Nojin9.xcodeproj`를 Xcode에서 엽니다.
3. signing team을 본인 개발 환경에 맞게 설정합니다.
4. iOS Simulator 또는 실제 기기에서 `Nojin9` target을 실행합니다.

## 참고할 만한 포인트

다른 Academy 러너나 외부 방문자가 이 프로젝트를 참고한다면 아래 지점을 중심으로 보면 좋습니다.

- SwiftUI `NavigationStack` 기반 화면 전환을 MVP에서 점진적으로 정리한 방식
- 대여/반납/감사 편지처럼 서로 연결된 기능을 하나의 사용자 여정으로 묶은 방식
- 실제 서버 없이 mock data store로 제품 흐름을 빠르게 검증한 방식
- Vision 기반 이미지 처리 실험을 앱 경험 안에 연결한 방식
- 기능 구현 후 PR 단위로 navigation regression을 계속 점검한 방식

## License

라이선스는 아직 지정되지 않았습니다. 외부 사용이나 재배포가 필요하다면 팀에 먼저 확인해 주세요.
