//
//  RentalView.swift
//  Nojin9
//
//  Created by 김가은 on 7/19/26.
//

import SwiftUI

struct RentalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore
    
    let itemID: String
    @State private var isShowingForm = false
    
    private var currentDetail: ClosetRentalItemDetail {
        RentalMockData.items[itemID] ?? RentalMockData.items["Top1"]!
    }

    private var currentStoreItem: ClothItem? {
        store.clothItem(imageName: itemID)
    }

    private var isAvailable: Bool {
        guard let currentStoreItem else { return currentDetail.isAvailable }
        return !currentStoreItem.isBorrowed
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // MARK: - Main Content Area
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // MARK: Navigation & Visual Section
                        ZStack(alignment: .topLeading) {
                            Image("RentalViewBackground")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 420)
                                .clipped()
                            
                            Image(currentDetail.id)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 340)
                                .centerView()
                                .padding(.top, 70)
                            
                            Text("1/1")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color("customWhite"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color("customBlack").opacity(0.4))
                                .clipShape(Capsule())
                                .padding(.trailing, 20)
                                .padding(.top, 380)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        // MARK: Item Meta Info Section
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 4) {
                                Text(currentDetail.owner)
                                    .font(.system(size: 13))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10))
                                Text(currentDetail.categoryName)
                                    .font(.system(size: 13))
                            }
                            .foregroundStyle(Color("gray40"))
                            .padding(.top, 20)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 12) {
                                Text(currentDetail.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Color("customBlack"))
                                
                                Text(isAvailable ? "빌려오기 가능" : "대여 중")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color("brandPrimary"))
                            }
                            .padding(.top, 8)
                            
                            Text("색상  \(currentDetail.color)")
                                .font(.system(size: 15))
                                .foregroundStyle(Color("customBlack"))
                                .padding(.top, 10)
                            
                            Divider()
                                .background(Color("gray10"))
                                .padding(.vertical, 16)
                            
                            HStack(spacing: 6) {
                                Image("Coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                
                                Text(formatNumber(currentDetail.price))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color("customBlack"))
                            }
                            
                            Text("현재 보유 하트 : \(formatNumber(store.currentUser?.point ?? 0))")
                                .font(.system(size: 12))
                                .foregroundStyle(Color("gray40"))
                                .padding(.top, 6)
                        }
                        .padding(.horizontal, 20)
                        
                        Rectangle()
                            .fill(Color("gray5"))
                            .frame(height: 8)
                            .padding(.top, 20)
                        
                        // MARK: Notice Section
                        VStack(alignment: .leading, spacing: 14) {
                            Text("주의 사항")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color("customBlack"))
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(currentDetail.notices, id: \.self) { notice in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(Color("brandPrimary"))
                                            .padding(.top, 3)
                                        
                                        Text(notice)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color("gray80"))
                                            .lineSpacing(4)
                                    }
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("brandPrimary10").opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Rectangle()
                            .fill(Color("gray5"))
                            .frame(height: 8)
                            .padding(.top, 20)
                        
                        // MARK: Thank You Letters Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("감사 편지 (\(currentDetail.thankYouLetters.count))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color("customBlack"))
                            
                            if currentDetail.thankYouLetters.isEmpty {
                                Text("아직 작성된 감사 편지가 없습니다.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color("gray40"))
                                    .padding(.vertical, 20)
                                    .centerView()
                            } else {
                                ForEach(currentDetail.thankYouLetters) { letter in
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(spacing: 10) {
                                            if letter.author == "나" {
                                                Image("MyProfile")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                            } else if letter.author.contains("둘째 언니") || letter.author.contains("둘째언니") {
                                                Image("2ndSisProfile")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                            } else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundStyle(Color("gray40"))
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(letter.author)
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundStyle(Color("customBlack"))
                                                Text(letter.date)
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(Color("gray40"))
                                            }
                                        }
                                        
                                        Text(letter.content)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color("customBlack"))
                                            .lineSpacing(4)
                                            .padding(.vertical, 2)
                                        
                                        if !letter.images.isEmpty {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 8) {
                                                    ForEach(letter.images, id: \.self) { imgName in
                                                        if UIImage(named: imgName) != nil {
                                                            Image(imgName)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 140, height: 140)
                                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                                        }
                                                    }
                                                }
                                                .padding(.leading, 20)
                                                .padding(.trailing, 20)
                                            }
                                            .padding(.horizontal, -20)
                                        }
                                    }
                                    .padding(.bottom, 24)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
                
                // MARK: Bottom Fixed CTA Button Section
                VStack(spacing: 0) {
                    Divider()
                        .background(Color("gray10"))
                    
                    Button(action: {
                        isShowingForm = true
                    }) {
                        Text("빌려오기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color("customWhite"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(isAvailable ? Color("brandPrimary") : Color("gray40"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!isAvailable)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .background(Color("customWhite"))
            }
            
            // MARK: - Fixed Floating Navigation Button
            BackButton {
                dismiss()
            }
            .padding(.leading, 20)
            .padding(.top, 60)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isShowingForm) {
            RentalFormView(itemID: itemID)
                .environmentObject(store)
        }
    }
    
    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}

private extension View {
    func centerView() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

#Preview {
    RentalView(itemID: "Top2")
        .environmentObject(AppDataStore())
}
