//
//  ClothItem.swift
//  Nojin9
//
//  Created by 김가은 on 7/17/26.
//


// 옷 카테고리
enum ClothCategory {
    case top
    case bottom
    case outer
    case dress
    case shoes
    case accessory
    case other
}

// 옷 상태
enum ClothCondition {
    case good
    case normal
    case damaged
}

// 대여 가능 여부
enum BorrowStatus {
    case available
    case borrowed
}

// 공개/보관 상태
enum ItemVisibilityStatus {
    case listed
    case stored
}


//func uploadItem(
//    title: String,
//    category: ClothCategory,
//    imageName: String?,
//    cutoutImageName: String?,
//    condition: ClothCondition
//) throws {
//    let item = ClothItem(
//        id: UUID(),
//        ownerId: userSession.currentUserId,
//        title: title,
//        category: category,
//        imageName: imageName,
//        cutoutImageName: cutoutImageName,
//        condition: condition,
//        borrowStatus: .available,
//        visibilityStatus: .listed
//    )
//
//    clothItems.append(item)
//
//    try validateDataIntegrity()
//    try saveSnapshot()
//}
