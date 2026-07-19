//
//
//  Created by Kim Seoyeon on 7/15/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(Color(.customWhite))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PrimaryDisabledButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(Color.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

//struct PrimaryDisabledButton: View {
//    let title: String
//    
//    var body: some View {
//        Button(action: { }) {
//            Text(title)
//                .font(.appButton)
//                .foregroundStyle(Color.customWhite)
//                .frame(maxWidth: .infinity)
//                .frame(height: 56)
//                .background(Color.gray20)
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//        }
//        .disabled(true)
//    }
//}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(Color.customWhite)
                .frame(maxWidth: .infinity)
                .frame(width: 129, height: 56)
                .background(.gray40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct OutlineButton: View {
    let title: String
    let action: () -> Void
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(.brandPrimary)
                .frame(maxWidth: .infinity)
                .frame(width: 129, height: 56)
                .background(.brandPrimary10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.brandPrimary, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PrimaryIconButton: View {
    let icon: Image
    let action: () -> Void
    init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24, height: 24)
                .clipShape(Circle())
        }
    }
}

struct OutlineIconButton: View {
    let icon: Image
    let action: () -> Void
    init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(.brandPrimary)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(.brandPrimary, lineWidth: 2)
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "빌려오기") {
        }
        
        
        HStack(spacing: 8) {
            SecondaryButton(title: "Back") {
            }
            
            PrimaryButton(title: "Next") {
            }
        }
        
        OutlineButton(title: "Write Notes") {
        }
        
        HStack(spacing: 20) {
            PrimaryIconButton(
                icon: Image(systemName: "chevron.right")
            ) {
            }
            OutlineIconButton(
                icon: Image(systemName: "exclamationmark")
            ) {
            }
        }
    }
    .padding()
}
