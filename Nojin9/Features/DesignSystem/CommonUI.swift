//
//
//  Created by Kim Seoyeon on 7/15/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PrimaryDisabledButton: View {
    let title: String
    
    var body: some View {
        Button(action: { }) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.gray20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(true)
    }
}

struct SecondaryButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(.customWhite)
                .frame(maxWidth: .infinity)
                .frame(width: 129, height: 56)
                .background(Color.gray40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct OutlineButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundStyle(Color.brandPrimary)
                .frame(maxWidth: .infinity)
                .frame(width: 129, height: 56)
                .background(Color.brandPrimary10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.brandPrimary, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PrimaryIconButton: View {
    let icon: Image
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(.customWhite)
                .frame(width: 24, height: 24)
                .background(Color.brandPrimary)
                .clipShape(Circle())
        }
    }
}

struct OutlineIconButton: View {
    let icon: Image
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.brandPrimary, lineWidth: 2)
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "빌려오기") {
        }
        
        PrimaryDisabledButton(title: "2,500하트로 빌려오기")
        
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
