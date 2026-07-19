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
                    .fill(.customBlack)
                    .frame(width: 79.62, height: 79.62)
                    .padding(.bottom, 20)

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
        .frame(width: 99.83)
    }
    .padding()
}
