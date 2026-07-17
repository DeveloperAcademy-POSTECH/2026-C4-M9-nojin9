//
//  NoteUI.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/15/26.
//

import SwiftUI

struct NoteButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {

                Image("NoteBody")
                    .resizable()
                    .scaledToFit()

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.customBlack)
                    .frame(width: 130, height: 130)
                    .padding(.bottom, 34)

                Image("NoteFlap")
                    .resizable()
                    .scaledToFit()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        NoteButton {
        }
        .frame(width: 163)
    }
    .padding()
}
