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
        .frame(width: 332, height: 46)
    }
}

struct PrimaryDisabledButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.gray20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(true)
    }
}

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
                .foregroundStyle(.customWhite)
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
                .foregroundStyle(.customWhite)
                .frame(width: 24, height: 24)
                .background(.brandPrimary)
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

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(.white.opacity(0.9))
                )
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.6), lineWidth: 1)
                )
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        }
        .buttonStyle(.plain)
    }
}

struct MyClosetButton: View {
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
                .frame(height: 43)
                .background(.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(width: 311, height: 43)
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
            BackButton{}
        }
    }
    .padding()
}
