//
//  Font.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/15/26.
//

import SwiftUI

// MARK: - Font

extension Font {

    static let title = Font.system(size: 26, weight: .bold)

    static let subtitleBold = Font.system(size: 20, weight: .bold)
    static let subtitle = Font.system(size: 20, weight: .regular)

    static let bodyBold = Font.system(size: 18, weight: .bold)
    static let body = Font.system(size: 18, weight: .regular)

    static let button = Font.system(size: 16, weight: .semibold)

    static let captionBold = Font.system(size: 14, weight: .semibold)
    static let caption = Font.system(size: 14, weight: .regular)
}

// MARK: - Text Style

extension Text {

    func titleStyle() -> some View {
        self
            .font(.title)
            .lineSpacing(32)
            .foregroundStyle(.black)
    }

    func subtitleBoldStyle() -> some View {
        self
            .font(.subtitleBold)
            .lineSpacing(24)
            .foregroundStyle(.black)
    }

    func subtitleStyle() -> some View {
        self
            .font(.subtitle)
            .lineSpacing(24)
            .foregroundStyle(.black)
    }

    func bodyBoldStyle() -> some View {
        self
            .font(.bodyBold)
            .lineSpacing(22)
            .foregroundStyle(.black)
    }

    func bodyStyle() -> some View {
        self
            .font(.body)
            .lineSpacing(24)
            .foregroundStyle(.black)
    }

    func buttonStyle() -> some View {
        self
            .font(.button)
            .lineSpacing(19)
            .foregroundStyle(.black)
    }

    func captionBoldStyle() -> some View {
        self
            .font(.captionBold)
            .lineSpacing(18)
            .foregroundStyle(.black)
    }

    func captionStyle() -> some View {
        self
            .font(.caption)
            .lineSpacing(18)
            .foregroundStyle(.black)
    }
}
