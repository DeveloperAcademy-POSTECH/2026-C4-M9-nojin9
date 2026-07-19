//
//  UploadView.swift
//  Nojin9
//

import SwiftUI

struct UploadView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var itemName = ""
    @State private var selectedCategory: ClothCategory?
    @State private var precautions = ""

    @State private var isShowingImageSource = false
    @State private var selectedImage: UIImage?

    private var canRegister: Bool {
        selectedImage != nil &&
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCategory != nil
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    navigationView

                    VStack(alignment: .leading, spacing: 22) {
                        photoSection
                        itemNameSection
                        categorySection
                        precautionsSection
                        registerButton
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 22)
                    .padding(.bottom, 30)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden()
        .confirmationDialog(
            "사진 첨부하기",
            isPresented: $isShowingImageSource,
            titleVisibility: .hidden
        ) {
            Button("사진 찍기") {
                // 카메라 화면 열기
            }

            Button("사진 보관함") {
                // 사진 보관함 열기
            }

            Button("취소", role: .cancel) { }
        }
    }
}

// MARK: - 상단 메뉴

private extension UploadView {
    var navigationView: some View {
        ZStack {
            Text("내 물품 등록하기")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(Circle())
                }

                Spacer()
            }
        }
        .frame(height: 52)
        .padding(.horizontal, 14)
    }
}

// MARK: - 사진 첨부

private extension UploadView {
    var photoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            requiredTitle("물품 사진")

            Button {
                isShowingImageSource = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(red: 0.94, green: 0.82, blue: 0.87))

                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)

                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                    } else {
                        VStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .fill(.brandPrimary)
                                    .opacity(0.2)
                                    .frame(width: 98, height: 98)

                                Image(systemName: "camera.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.brandPrimary)
                            }

                            Text("사진 첨부하기")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }
                .frame(height: 240)
            }
            .buttonStyle(.plain)

            if selectedImage != nil {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark")
                    Text("사진이 첨부되었습니다.")
                }
                .font(.system(size: 14))
                .foregroundStyle(.pink)
                .padding(.horizontal, 12)
            }
        }
    }
}

// MARK: - 물품 이름

private extension UploadView {
    var itemNameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            requiredTitle("물품 이름")

            TextField("회색 오프숄더 니트", text: $itemName)
                .font(.system(size: 16))
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                }
        }
    }
}

// MARK: - 카테고리

private extension UploadView {
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("물품 카테고리")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)

            HStack(spacing: 10) {
                categoryButton(
                    title: "상의",
                    category: .top
                )

                categoryButton(
                    title: "하의",
                    category: .bottom
                )

                categoryButton(
                    title: "기타",
                    category: .other
                )
            }
        }
    }

    func categoryButton(
        title: String,
        category: ClothCategory
    ) -> some View {
        let isSelected = selectedCategory == category

        return Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    isSelected ? Color.white : Color.black.opacity(0.8)
                )
                .padding(.horizontal, 22)
                .frame(height: 40)
                .background(
                    isSelected
                        ? Color.pink
                        : Color.gray.opacity(0.06)
                )
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected
                                ? Color.pink
                                : Color.gray.opacity(0.4),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 주의사항

private extension UploadView {
    var precautionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주의사항")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)

            Text("주의사항은 항목별로 줄바꿈해 주세요.")
                .font(.system(size: 14))
                .foregroundStyle(.gray)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $precautions)
                    .font(.system(size: 16))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(height: 125)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)

                if precautions.isEmpty {
                    Text(
                        """
                        옷이 잘 늘어나니 주의 필요함.
                        오염있으면 문지르지 말고 그대로 둬야함.
                        (드라이클리닝 해야함)
                        """
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray.opacity(0.6))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 15)
                    .allowsHitTesting(false)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.35), lineWidth: 1)
            }
        }
    }
}

// MARK: - 등록 버튼

private extension UploadView {
    var registerButton: some View {
        Button {
            registerItem()
        } label: {
            Text("등록하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    canRegister
                        ? Color.pink
                        : Color.gray.opacity(0.55)
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(!canRegister)
    }

    func registerItem() {
        guard let selectedCategory else {
            return
        }

        print("물품 이름:", itemName)
        print("카테고리:", selectedCategory)
        print("주의사항:", precautions)

        // 이후 AppDataStore에 ClothItem을 추가
    }
}

// MARK: - 공통 UI

private extension UploadView {
    func requiredTitle(_ title: String) -> some View {
        HStack(spacing: 7) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)

            Text("필수")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.pink)
        }
    }
}


#Preview {
    NavigationStack {
        UploadView()
    }
}
