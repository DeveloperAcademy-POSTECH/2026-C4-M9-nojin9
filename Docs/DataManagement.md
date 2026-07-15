# C4 MVP 데이터 구조 및 관리 방식

이 문서는 C4 MVP 앱을 구현할 때 팀원이 같은 기준으로 데이터 구조, 화면 필터, 상태 변경 규칙을 이해하기 위한 공유 문서다.

## 1. 한 줄 요약

앱은 서버 없이 로컬 JSON 데이터로 동작한다. 현재 로그인한 유저는 `currentUserId` 하나로 판단하고, 모든 화면은 이 UUID를 기준으로 다시 계산한다.

## 2. 핵심 원칙

| 구분 | 결정 |
| --- | --- |
| 로그인 | 실제 로그인 서버 없이 `UserSession.currentUserId`로 현재 유저를 전환한다. |
| 데이터 연결 | 모든 핵심 데이터는 `UUID`로 연결한다. |
| 데이터 저장 | 앱을 껐다 켜도 유지되도록 `Codable + JSON file`로 저장한다. |
| 대여 상태 | 대여 이력의 기준 진실은 `Rental.status`다. |
| 옷 현재 상태 | 화면의 빠른 현재 상태 표시는 `ClothItem.borrowStatus`를 쓴다. |
| 보관 | `ClothItem.visibilityStatus = stored`로 처리한다. 상품은 보이지만 대여는 불가능하다. |
| 삭제 | 삭제 시 `ClothItem`은 실제 `clothItems` 배열에서 제거한다. |
| 리뷰 | 리뷰는 유저가 아니라 상품(`itemId`)에 남긴다. |
| 업로드 요청 | 요청 수락 후 실제 상품이 생성되면 요청자 정보와 요청 기록은 상품에 남기지 않는다. |
| 친구 관계 | UUID 문자열 알파벳 순으로 `userAId`, `userBId`를 정규화한다. |

## 3. MVP 기능 범위

| 기능 | P0 포함 여부 | 핵심 데이터 |
| --- | --- | --- |
| 가입 | 포함 | `User` |
| 탈퇴 | 포함 | `User`, `Rental`, `ClothItemRequest`, `Friendship` |
| 개발용 유저 전환 | 포함 | `UserSession` |
| 옷 업로드 | 포함 | `ClothItem` |
| 옷 업로드 요청 | 포함 | `ClothItemRequest`, `ClothItem` |
| 옷 보관 / 보관 해제 | 포함 | `ClothItem` |
| 옷 삭제 | 포함 | `ClothItem`, `Review`, `Rental` |
| 1:1 맞팔로우 | 포함 | `Friendship` |
| 대여 | 포함 | `Rental`, `ClothItem` |
| 반납 | 포함 | `Rental`, `ClothItem` |
| 리뷰 남기기 | 포함 | `Review` |
| 훼손 신고 | P1 | `DamageReport` |
| 포인트 이력 | P1 | `PointTransaction` |
| 유저 블락 | 현재 미사용 | 없음 |

## 4. 데이터 전체 구조

```text
AppDataStore
├─ users: [User]
├─ userSession: UserSession
├─ clothItems: [ClothItem]
├─ clothItemRequests: [ClothItemRequest]
├─ friendships: [Friendship]
├─ rentals: [Rental]
└─ reviews: [Review]
```

| 데이터 | 역할 |
| --- | --- |
| `User` | 앱 안의 유저. 옷 소유자이자 대여자가 될 수 있다. |
| `UserSession` | 현재 앱을 보고 있는 유저의 UUID를 저장한다. |
| `ClothItem` | 실제 옷 상품 데이터다. |
| `ClothItemRequest` | 다른 유저에게 옷을 추가해 달라고 요청하는 임시 데이터다. |
| `Friendship` | 1:1 맞팔로우 관계다. |
| `Rental` | 대여/반납 이력이다. |
| `Review` | 상품에 남기는 리뷰다. |

## 5. 모델 정의

### 5.1 User

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 유저 고유 ID |
| `name` | `String` | 유저 이름 |
| `profileImageName` | `String?` | 프로필 이미지 이름 |
| `points` | `Int` | 현재 포인트. P0에서는 단순 값으로만 사용 |
| `status` | `UserStatus` | `active`, `withdrawn` |
| `createdAt` | `Date` | 생성일 |
| `withdrawnAt` | `Date?` | 탈퇴일 |

| 상태 | 의미 |
| --- | --- |
| `active` | 정상 사용 가능 |
| `withdrawn` | 탈퇴한 유저 |

운영 기준:

- 탈퇴해도 `User`는 삭제하지 않고 `status = withdrawn`으로 바꾼다.
- 탈퇴 유저는 개발용 유저 전환 목록에서 제외한다.
- 탈퇴 유저가 포함된 진행 중 대여가 있으면 탈퇴할 수 없다.
- 과거 `Rental`, `Review` 기록은 유지한다.

### 5.2 UserSession

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `currentUserId` | `UUID` | 현재 앱을 보고 있는 유저 ID |

운영 기준:

- 앱은 전체 유저 객체를 로그인 상태로 들고 있지 않는다.
- 개발용 숨김 버튼으로 `User A / B / C / D`를 전환한다.
- 유저를 전환하면 모든 화면은 `currentUserId` 기준으로 다시 필터링한다.

### 5.3 ClothItem

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 상품 고유 ID |
| `ownerId` | `UUID` | 실제 옷 소유자 |
| `title` | `String` | 상품 이름 |
| `category` | `ClothCategory` | 옷 카테고리 |
| `imageName` | `String?` | 원본 이미지 이름 |
| `cutoutImageName` | `String?` | 누끼 이미지 이름 |
| `condition` | `ClothCondition` | 옷 상태 |
| `borrowStatus` | `BorrowStatus` | 현재 대여 가능 여부 |
| `visibilityStatus` | `ItemVisibilityStatus` | 공개/보관 상태 |

| enum | 값 |
| --- | --- |
| `ClothCategory` | `top`, `bottom`, `outer`, `dress`, `shoes`, `accessory`, `other` |
| `ClothCondition` | `good`, `normal`, `damaged` |
| `BorrowStatus` | `available`, `borrowed` |
| `ItemVisibilityStatus` | `listed`, `stored` |

운영 기준:

| 상황 | 처리 |
| --- | --- |
| 직접 업로드 | `ownerId = currentUserId` |
| 요청 수락 후 생성 | `ownerId = 실제 소유자` |
| 대여 시작 | `borrowStatus = borrowed` |
| 반납 완료 | `borrowStatus = available` |
| 보관 | `visibilityStatus = stored` |
| 보관 해제 | `visibilityStatus = listed` |
| 삭제 | `clothItems` 배열에서 실제 제거 |

보관/삭제 표시 기준:

| 상태 | 다른 유저에게 보임 | 상품 상세 접근 | 대여 가능 | 리뷰 표시 |
| --- | --- | --- | --- | --- |
| `listed` | 가능 | 가능 | 가능 | 가능 |
| `stored` | 가능 | 가능. "보관된 상품입니다" 표시 | 불가능 | 가능 |
| 삭제됨 | 불가능 | 불가능. "상품을 이용할 수 없습니다" 표시 | 불가능 | "삭제된 상품"으로 리뷰만 표시 |

### 5.4 ClothItemRequest

다른 유저의 옷장에 없는 옷을 대여하고 싶을 때, 대여자가 소유자에게 "이 옷도 추가해 주세요"라고 요청하는 데이터다.

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 요청 고유 ID |
| `requesterId` | `UUID` | 요청한 유저 |
| `ownerId` | `UUID` | 요청을 받는 실제 옷 소유자 |
| `title` | `String?` | 요청 상품 이름 |
| `imageName` | `String?` | 요청 이미지 |
| `message` | `String?` | 요청 메시지 |
| `status` | `ClothItemRequestStatus` | `pending`, `accepted`, `rejected` |
| `createdAt` | `Date` | 요청 생성일 |

운영 기준:

| 상황 | 처리 |
| --- | --- |
| 요청 생성 | `pending` 요청을 만든다. |
| 중복 요청 | 같은 요청자, 같은 소유자, 같은 이미지나 제목의 `pending` 요청은 막는다. |
| 소유자 수락 | 새 `ClothItem`을 만들고 요청은 활성 배열에서 제거한다. |
| 소유자 거절 | `ClothItem`을 만들지 않고 요청은 활성 배열에서 제거한다. |
| 상품 생성 후 | 실제 상품에는 요청자 정보를 남기지 않는다. |

### 5.5 Friendship

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 관계 고유 ID |
| `userAId` | `UUID` | UUID 문자열 기준 더 작은 유저 ID |
| `userBId` | `UUID` | UUID 문자열 기준 더 큰 유저 ID |
| `status` | `FriendshipStatus` | `requested`, `accepted` |
| `requestedByUserId` | `UUID` | 처음 요청한 유저 |
| `createdAt` | `Date` | 생성일 |
| `acceptedAt` | `Date?` | 수락일 |

운영 기준:

| 규칙 | 설명 |
| --- | --- |
| 정규화 | UUID 문자열 알파벳 순으로 작은 값이 `userAId`, 큰 값이 `userBId` |
| 중복 방지 | 같은 `userAId + userBId` 조합은 하나만 존재 |
| 반대 방향 요청 | 새로 만들지 않고 기존 요청을 찾아 처리 |
| 옷장 접근 | `status == accepted`일 때만 상대 옷장 접근 가능 |
| 블락 | 현재 MVP에서 사용하지 않음 |

Helper 기준:

```swift
func normalizedPair(_ firstUserId: UUID, _ secondUserId: UUID) -> (userAId: UUID, userBId: UUID) {
    if firstUserId.uuidString < secondUserId.uuidString {
        return (firstUserId, secondUserId)
    } else {
        return (secondUserId, firstUserId)
    }
}

func friendId(for currentUserId: UUID) -> UUID? {
    if userAId == currentUserId { return userBId }
    if userBId == currentUserId { return userAId }
    return nil
}
```

### 5.6 Rental

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 대여 고유 ID |
| `itemId` | `UUID` | 대여한 상품 ID |
| `ownerId` | `UUID` | 상품 소유자 |
| `borrowerId` | `UUID` | 빌린 유저 |
| `status` | `RentalStatus` | `borrowed`, `returned` |
| `borrowedAt` | `Date` | 대여일 |
| `dueAt` | `Date?` | 반납 예정일 |
| `returnedAt` | `Date?` | 실제 반납일 |
| `createdAt` | `Date` | 기록 생성일 |

운영 기준:

| 상황 | 처리 |
| --- | --- |
| 대여 시작 | 새 `Rental` 생성, `status = borrowed`, 상품 `borrowStatus = borrowed` |
| 일반 반납 | `Rental.status = returned`, `returnedAt` 기록, 상품 `borrowStatus = available` |
| 보관/삭제 직전 강제 반납 | 소유자만 가능. 이 케이스에서만 허용 |
| 대여 승인 상태 | 사용하지 않음 |
| 대여 취소 상태 | 사용하지 않음 |

### 5.7 Review

리뷰는 유저가 아니라 상품에 남긴다.

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | `UUID` | 리뷰 고유 ID |
| `rentalId` | `UUID` | 어떤 대여 건에서 작성됐는지 |
| `itemId` | `UUID` | 어떤 상품에 대한 리뷰인지 |
| `reviewerId` | `UUID` | 리뷰 작성자 |
| `message` | `String` | 리뷰 내용 |
| `imageNames` | `[String]` | 리뷰 이미지 이름 목록. 복수 이미지 가능 |
| `createdAt` | `Date` | 작성일 |

운영 기준:

| 상황 | 처리 |
| --- | --- |
| 리뷰 작성 가능 | `Rental.status == returned`이고 작성자가 `borrowerId`인 경우 |
| 중복 방지 | `rentalId + reviewerId` 조합은 하나만 허용 |
| 상품 소유자 탈퇴 | 반납 완료 상태라면 리뷰 작성 가능 |
| 상품 보관 | 리뷰 유지, 상품 상세 접근 가능, 대여만 불가 |
| 상품 삭제 | 리뷰 유지, 상품 정보는 "삭제된 상품"으로 표시 |

## 6. 화면별 데이터 필터

| 화면 | 필터 기준 | 비고 |
| --- | --- | --- |
| 내 옷장 | `ownerId == currentUserId` | 보관 상품도 포함 가능 |
| 내 보관함 | `ownerId == currentUserId && visibilityStatus == stored` | 소유자 전용 관리 화면 |
| 친구 옷장 | `ownerId == selectedFriendId && visibilityStatus in [listed, stored]` | 보관 상품은 보이지만 대여 불가 |
| 내가 빌린 대여 | `borrowerId == currentUserId` | 진행 중/완료 구분은 `Rental.status` |
| 내가 빌려준 대여 | `ownerId == currentUserId` | 진행 중/완료 구분은 `Rental.status` |
| 받은 업로드 요청 | `ownerId == currentUserId` | 활성 `pending`만 표시 |
| 보낸 업로드 요청 | `requesterId == currentUserId` | 활성 `pending`만 표시 |
| 상품 리뷰 | `itemId == selectedItemId` | 삭제 상품이면 "삭제된 상품" 표시 |
| 리뷰 가능 목록 | `status == returned && reviewerId 기준 중복 리뷰 없음` | 대여자만 작성 가능 |

## 7. 주요 플로우

### 7.1 개발용 유저 전환

| 단계 | 처리 |
| --- | --- |
| 1 | 앱 구석의 개발용 숨김 버튼을 누른다. |
| 2 | `User A / B / C / D` 중 하나를 선택한다. |
| 3 | `UserSession.currentUserId`를 선택한 유저 UUID로 바꾼다. |
| 4 | 모든 화면이 `currentUserId` 기준으로 다시 계산된다. |

### 7.2 대여

| 단계 | 처리 |
| --- | --- |
| 1 | 대여자가 친구 옷장에서 상품을 선택한다. |
| 2 | 대여 가능 조건을 확인한다. |
| 3 | 조건을 통과하면 `Rental`을 생성한다. |
| 4 | `Rental.status = borrowed`로 저장한다. |
| 5 | `ClothItem.borrowStatus = borrowed`로 함께 변경한다. |
| 6 | 변경 후 JSON 스냅샷을 저장한다. |

대여 가능 조건:

```swift
canBorrow =
    borrower.id != owner.id &&
    borrower.status == .active &&
    owner.status == .active &&
    friendship.status == .accepted &&
    item.ownerId == owner.id &&
    item.borrowStatus == .available &&
    item.visibilityStatus == .listed &&
    activeRental(for: item.id) == nil
```

### 7.3 반납

| 단계 | 처리 |
| --- | --- |
| 1 | 진행 중인 `Rental`을 찾는다. |
| 2 | `Rental.status = returned`로 바꾼다. |
| 3 | `returnedAt`을 기록한다. |
| 4 | `ClothItem.borrowStatus = available`로 함께 바꾼다. |
| 5 | 변경 후 JSON 스냅샷을 저장한다. |

### 7.4 보관

| 단계 | 처리 |
| --- | --- |
| 1 | 소유자가 자신의 상품에서 보관을 선택한다. |
| 2 | 진행 중 대여가 있는지 확인한다. |
| 3 | 대여 중이면 소유자가 강제 반납 후 보관할 수 있다. |
| 4 | 강제 반납은 보관/삭제 직전 케이스에서만 허용한다. |
| 5 | `visibilityStatus = stored`로 바꾼다. |
| 6 | 상품은 보이지만 대여 버튼은 비활성화한다. |

### 7.5 삭제

| 단계 | 처리 |
| --- | --- |
| 1 | 소유자가 자신의 상품에서 삭제를 선택한다. |
| 2 | 진행 중 대여가 있는지 확인한다. |
| 3 | 대여 중이면 소유자가 강제 반납 후 삭제할 수 있다. |
| 4 | 강제 반납은 보관/삭제 직전 케이스에서만 허용한다. |
| 5 | `clothItems` 배열에서 해당 `ClothItem`을 실제 제거한다. |
| 6 | 리뷰/과거 대여 화면에서는 `itemId` 조회 실패 시 "삭제된 상품"으로 표시한다. |
| 7 | 삭제된 상품 상세 접근은 "상품을 이용할 수 없습니다"로 막는다. |

### 7.6 옷 업로드 요청

| 단계 | 처리 |
| --- | --- |
| 1 | 대여자가 친구 옷장에 없는 옷을 촬영하거나 설명한다. |
| 2 | 같은 요청자, 같은 소유자, 같은 이미지/제목의 `pending` 요청이 있는지 확인한다. |
| 3 | 중복이 아니면 `ClothItemRequest`를 만든다. |
| 4 | 소유자가 수락하면 새 `ClothItem`을 만든다. |
| 5 | 생성된 상품의 `ownerId`는 실제 소유자다. |
| 6 | 상품에는 요청자 정보나 생성 경로 정보를 남기지 않는다. |
| 7 | 수락/거절이 끝난 요청은 활성 `clothItemRequests` 배열에서 제거한다. |

### 7.7 탈퇴

| 단계 | 처리 |
| --- | --- |
| 1 | 진행 중 대여가 있는지 확인한다. |
| 2 | 진행 중 대여가 있으면 탈퇴를 막는다. |
| 3 | 진행 중 대여가 없으면 `User.status = withdrawn`으로 바꾼다. |
| 4 | `withdrawnAt`을 기록한다. |
| 5 | 탈퇴 유저는 유저 전환 목록에서 제외한다. |
| 6 | 탈퇴 유저가 포함된 `pending` 요청은 활성 목록에서 제외한다. |
| 7 | 과거 대여/리뷰 기록은 유지한다. |

## 8. AppDataStore 액션

| 액션 | 역할 |
| --- | --- |
| `switchUser(to:)` | 현재 유저 전환 |
| `createUser(...)` | 새 유저 생성 |
| `withdrawUser(userId:)` | 탈퇴 처리 |
| `uploadItem(...)` | 소유자 직접 상품 업로드 |
| `storeItem(itemId:)` | 상품 보관 |
| `restoreStoredItem(itemId:)` | 보관 해제 |
| `deleteItem(itemId:)` | 상품 실제 삭제 |
| `forceReturnForStorageOrDeletion(itemId:)` | 보관/삭제 직전 소유자 강제 반납 |
| `createItemRequest(...)` | 옷 업로드 요청 생성 |
| `acceptItemRequest(requestId:)` | 요청 수락 후 상품 생성 |
| `rejectItemRequest(requestId:)` | 요청 거절 |
| `createFriendship(requesterId:receiverId:)` | 맞팔로우 요청 생성 |
| `acceptFriendship(friendshipId:)` | 맞팔로우 수락 |
| `borrowItem(itemId:borrowerId:)` | 대여 생성 |
| `returnItem(rentalId:)` | 반납 처리 |
| `createReview(rentalId:reviewerId:...)` | 상품 리뷰 생성 |

## 9. 동기화 불변식

상태 변경은 화면에서 직접 하지 않고 반드시 `AppDataStore` 액션을 통해 처리한다.

| 규칙 | 의미 |
| --- | --- |
| `activeRental(for: item.id) == nil -> item.borrowStatus == .available` | 진행 중 대여가 없으면 상품은 대여 가능 상태여야 한다. |
| `activeRental(for: item.id) != nil -> item.borrowStatus == .borrowed` | 진행 중 대여가 있으면 상품은 대여 중이어야 한다. |
| `borrowed` 상태의 `Rental`은 상품당 최대 1개 | 한 상품을 동시에 여러 명이 빌릴 수 없다. |
| 저장 전 `validateDataIntegrity()` 실행 | 상태가 어긋나면 저장하지 않는다. |
| 삭제 상품 조회 실패 | 리뷰/과거 대여 화면에서는 "삭제된 상품"으로 처리한다. |

## 10. 로컬 저장 방식

P0에서도 앱을 껐다 켜면 데이터가 유지되어야 한다. 그래서 메모리 MockData만 쓰지 않고 JSON 파일로 저장한다.

### 10.1 왜 SwiftData가 아니라 JSON인가

이번 MVP에서는 SwiftData보다 JSON이 더 적합하다. 이유는 이 단계의 목표가 완성형 로컬 데이터베이스를 만드는 것이 아니라, 팀이 데이터 구조와 대여/반납/보관/삭제 흐름을 빠르게 검증하는 것이기 때문이다.

| 기준 | JSON | SwiftData |
| --- | --- | --- |
| 구조 확인 | 파일을 열어 전체 데이터를 바로 볼 수 있다. | 내부 저장 구조를 직접 확인하기 어렵다. |
| 디버깅 | 어떤 값이 저장됐는지 추적하기 쉽다. | 모델, 컨텍스트, 쿼리 흐름을 함께 봐야 한다. |
| 변경 대응 | 모델이 자주 바뀌어도 스냅샷을 수정하거나 초기화하기 쉽다. | 모델 변경 시 마이그레이션을 고려해야 한다. |
| 팀 공유 | 샘플 JSON을 공유하면 같은 상태로 테스트하기 쉽다. | 로컬 DB 상태 공유가 번거롭다. |
| 서버 전환 | 나중에 서버 API 응답 구조로 바꾸기 쉽다. | 서버 DB와 로컬 DB 동기화 규칙이 추가로 필요하다. |

서버가 생기면 진짜 데이터의 기준은 앱 내부가 아니라 서버 DB가 된다. 따라서 지금부터 SwiftData로 앱 안에 강한 로컬 DB 구조를 만들기보다, `AppDataStore` 뒤에 JSON 저장소를 두고 나중에 이 부분을 서버 API로 교체할 수 있게 만드는 편이 더 안전하다.

결론:

```text
지금: AppDataStore + Codable JSON
나중: AppDataStore + Server API
필요할 때만: SwiftData 또는 다른 로컬 캐시
```

### 10.2 저장 단위

```swift
AppDataSnapshot: Codable
- users: [User]
- userSession: UserSession
- clothItems: [ClothItem]
- clothItemRequests: [ClothItemRequest]
- friendships: [Friendship]
- rentals: [Rental]
- reviews: [Review]
- savedAt: Date
```

### 10.3 저장 규칙

| 상황 | 처리 |
| --- | --- |
| 앱 시작 | JSON 파일에서 `AppDataSnapshot`을 로드한다. |
| 저장 파일 없음 | 초기 MockData를 만들고 즉시 저장한다. |
| 상태 변경 성공 | 전체 스냅샷을 다시 저장한다. |
| 유저 전환 | `UserSession.currentUserId`도 함께 저장한다. |
| 개발용 초기화 | 별도 reset 액션으로만 처리한다. |
| 저장 방식 | 핵심 데이터는 JSON 파일, 단순 설정은 `UserDefaults` |

### 10.4 저장 실패 처리

| 상황 | 처리 |
| --- | --- |
| 저장 시도 | 임시 파일에 먼저 쓴다. |
| 저장 성공 | 임시 파일로 기존 파일을 교체한다. |
| 저장 실패 | 기존 저장 파일을 덮어쓰지 않는다. |
| 저장 실패 후 화면 | "저장 실패: 앱을 종료하면 최근 변경이 사라질 수 있습니다" 표시 |
| 사용자 액션 | 저장 재시도 제공 |
| 위험 액션 | 저장 실패 해결 전 개발용 reset 같은 파괴적 액션은 막는다. |
| 앱 시작 로드 실패 | 자동으로 MockData로 덮어쓰지 않고 오류 상태를 표시한다. |

## 11. 추천 파일 구조

기능별 화면과 상태 관리가 함께 움직이므로, `Models`와 `ViewModels`를 전역 폴더로 나누기보다 Feature 단위로 묶는다. 여러 Feature가 함께 쓰는 저장소, MockData, JSON 저장 로직은 `Data`에 두고, 공통 유틸은 `Core`에 둔다.

```text
Nojin9/
  App/
    Nojin9App.swift
  Features/
    UserSession/
      UserSessionModel.swift
      UserSessionViewModel.swift
    Closet/
      ClosetModel.swift
      ClosetViewModel.swift
    FriendCloset/
      FriendClosetModel.swift
      FriendClosetViewModel.swift
    ClothItemRequest/
      ClothItemRequestModel.swift
      ClothItemRequestViewModel.swift
    Rental/
      RentalModel.swift
      RentalViewModel.swift
    Review/
      ReviewModel.swift
      ReviewViewModel.swift
  Core/
    Extensions/
    Utils/
  Data/
    MockUsers.swift
    MockClothItems.swift
    MockClothItemRequests.swift
    MockRentals.swift
    MockReviews.swift
    AppDataSnapshot.swift
    LocalDataStorage.swift
    AppDataStore.swift
  Resources/
    Assets.xcassets
    Fonts/
  Supporting Files/
    Info.plist
```

## 12. ViewModel 책임

| ViewModel | 책임 |
| --- | --- |
| `UserSessionViewModel` | 개발용 유저 전환, `currentUserId` 관리 |
| `ClosetViewModel` | 내 옷장, 내 보관함, 보관/보관 해제, 삭제 |
| `FriendClosetViewModel` | 친구 옷장, 보관 상품 표시, 대여 가능 목록, 대여 액션 |
| `ClothItemRequestViewModel` | 받은 요청, 보낸 요청, 요청 생성/수락/거절 |
| `RentalViewModel` | 내가 빌린 대여, 내가 빌려준 대여, 반납, 보관/삭제 직전 강제 반납 |
| `ReviewViewModel` | 상품 리뷰 목록, 리뷰 작성 가능 여부, 삭제된 상품 리뷰 표시 |

## 13. 구현 체크리스트

| 체크 | 기준 |
| --- | --- |
| 유저 전환 | `currentUserId`만 바꿔도 모든 화면이 바뀐다. |
| 친구 옷장 | 맞팔로우 `accepted`일 때만 볼 수 있다. |
| 보관 상품 | 다른 유저에게 보일 수 있지만 대여 버튼은 비활성화된다. |
| 삭제 상품 | `clothItems`에서 제거되고 리뷰에는 "삭제된 상품"으로만 남는다. |
| 대여 | `Rental.status`와 `ClothItem.borrowStatus`가 같이 바뀐다. |
| 반납 | `Rental.status`와 `ClothItem.borrowStatus`가 같이 바뀐다. |
| 강제 반납 | 소유자가 보관/삭제 직전 케이스에서만 할 수 있다. |
| 리뷰 | 반납 완료 후 대여자가 상품에 1회만 남길 수 있다. |
| 업로드 요청 | 수락/거절 후 활성 요청 배열에서 제거된다. |
| 저장 | 앱 재실행 후에도 데이터가 유지된다. |
| 저장 실패 | 기존 파일을 보존하고 사용자에게 재시도를 제공한다. |
