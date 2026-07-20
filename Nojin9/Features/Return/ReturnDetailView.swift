//
//  ReturnDetailView.swift
//  Nojin9
//
//  Created by 김가은 on 7/20/26.
//

import PhotosUI
import SwiftUI

struct ReturnDetailView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss
    
    let rental: Rental
    let item: ClothItem
    let onHomeButtonTapped: () -> Void

    init(
        rental: Rental,
        item: ClothItem,
        onHomeButtonTapped: @escaping () -> Void = { }
    ) {
        self.rental = rental
        self.item = item
        self.onHomeButtonTapped = onHomeButtonTapped
    }
    
    @State private var isDamaged = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var damagedImage: UIImage?
    @State private var isReturnCompleted = false
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                navigationBar
                VStack(spacing: 0) {
                    itemCard
                    
                    washConfirmation
                    
                    washingMachineView
                }
                
                returnButton
            }
            if isReturnCompleted {
                returnCompletedOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    .zIndex(10)
            }
            
        }
        .animation(
            .spring(response: 0.4, dampingFraction: 0.75),
            value: isReturnCompleted
        )
        .navigationBarBackButtonHidden()
    }
    
    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var navigationBar: some View {
        ToolbarUI(
            mode: .returnRequest,
            onBack: {
                dismiss()
            }
        )
        .padding(.top, 10)
    }
    
    private var itemCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("반납 물품")
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 10)
                .padding(.leading, 16)
            HStack(spacing: 12) {
                ZStack {
                    Color.brandPrimary10
                    
                    if let imageName = item.cutoutImageName ?? item.imageName {
                        ClothImageView(imageName: imageName)
                            .scaledToFit()
                            .padding(8)
                    } else {
                        Image(systemName: "tshirt")
                            .font(.system(size: 32))
                    }
                }
                .frame(width: 82, height: 82)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                        
                        Text(dDayText)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.pink.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Text(rentalPeriodText)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(.customWhite.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        
    }
    
    private var washConfirmation: some View {
        Toggle(isOn: $isDamaged) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.brandPrimary)
                
                Text("돌려줄 물건을 훼손하셨나요?")
                    .font(.system(size: 15, weight: .semibold))
            }
        }
        .tint(.green)
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .onChange(of: isDamaged) { _, newValue in
            if !newValue {
                selectedPhoto = nil
                damagedImage = nil
            }
        }
    }
    
    private var washingMachineView: some View {
        VStack(spacing: 10) {
            ZStack {
                Image(isDamaged ? "LaundryAbled" : "LaundryDisabled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 439)
                
                if isDamaged {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        if let damagedImage {
                            Image(uiImage: damagedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 225, height: 225)
                                .clipShape(Circle())
                                .padding(.top, 12)
                                .padding(.leading, 4)
                        } else {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(.brandPrimary)
                                .frame(width: 72, height: 72)
                                .background(.brandPrimary.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                    }
                    .accessibilityLabel("훼손된 물품 사진 첨부")
                }
                
                //                if isDamaged {
                //                    Text("훼손된 물품의 사진을 첨부해 주세요.")
                //                        .font(.system(size: 13, weight: .medium))
                //                        .foregroundStyle(.gray60)
                //                }
                
            }
            
            
        }
        .padding(.horizontal, 26)
        .onChange(of: selectedPhoto) { _, newPhoto in
            guard let newPhoto else { return }
            
            Task {
                guard
                    let data = try? await newPhoto.loadTransferable(type: Data.self),
                    let image = UIImage(data: data)
                else {
                    return
                }
                
                await MainActor.run {
                    damagedImage = image
                }
            }
        }
    }
    
    private var canReturn: Bool {
        !isDamaged || damagedImage != nil
    }
    
    private var returnButton: some View {
        Button {
                isReturnCompleted = true
            } label: {
                Text("돌려주기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.customWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 47)
                    .background(canReturn ? .brandPrimary : .gray20)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        .disabled(!canReturn)
        .padding(.top, 20)
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(
            Color.customWhite
                .ignoresSafeArea()
        )
    }
    
    private var rentalPeriodText: String {
        let start = rental.borrowedAt.returnDateText
        let end = rental.dueAt?.returnDateText ?? "미정"
        
        return "\(start) ~ \(end)"
    }
    
    private var dDayText: String {
        guard let dueAt = rental.dueAt else {
            return "기한 미정"
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueDate = calendar.startOfDay(for: dueAt)
        
        let difference = calendar.dateComponents(
            [.day],
            from: today,
            to: dueDate
        ).day ?? 0
        
        if difference < 0 {
            return "D+\(abs(difference))"
        }
        
        if difference == 0 {
            return "D-Day"
        }
        
        return "D-\(difference)"
    }
    
    private var returnCompletedOverlay: some View {
        ZStack {
            Color.customBlack.opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                Image("ReturnCompleteSticker")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330, height: 330)
                    .offset(x: 0, y: 220)
                
                
                Text("훼손 인정 시 보상이 자동으로 상대에게 지급됩니다.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray10)
                    .padding(.bottom, 10)
                    .padding(.top, 300)
                
                VStack {
                    Button {
                        completeReturnAndDismiss()
                    } label: {
                        Text("돌려주기 리스트로 가기")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.customWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 47)
                            .background(.brandPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
                    Button {
                        moveToHome()
                    } label: {
                        Text("홈으로 돌아가기")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.brandPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 47)
                            .background(.brandPrimary10)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func completeReturnAndDismiss() {
        guard store.returnRental(id: rental.id) else {
            return
        }

        dismiss()
    }
    
    private func moveToHome() {
        let rentalId = rental.id
        
        dismiss()
        
        DispatchQueue.main.async {
            _ = store.returnRental(id: rentalId)
            onHomeButtonTapped()
        }
    }
}
#Preview {
    NavigationStack {
        ReturnDetailView(
            rental: MockData.rentals[1],
            item: MockData.clothItems[4]
        )
        .environmentObject(AppDataStore())
    }
}
