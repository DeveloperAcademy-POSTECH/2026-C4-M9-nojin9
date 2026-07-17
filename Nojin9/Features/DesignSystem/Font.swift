//
//  Font.swift
//  Nojin9
//
//  Created by Kimseoyeon on 7/15/26.
//

import SwiftUI

// MARK: - Font

extension Font {

    static let appTitle = Font.system(size: 26, weight: .bold)

    static let appSubtitleBold = Font.system(size: 20, weight: .bold)
    static let appSubtitle = Font.system(size: 20, weight: .regular)

    static let appBodyBold = Font.system(size: 18, weight: .bold)
    static let appBody = Font.system(size: 18, weight: .regular)

    static let appButton = Font.system(size: 16, weight: .semibold)

    static let appCaptionBold = Font.system(size: 14, weight: .semibold)
    static let appCaption = Font.system(size: 14, weight: .regular)
}

private enum AppLineSpacing {
    static let title: CGFloat = 32 - 26
    static let subtitle: CGFloat = 24 - 20
    static let bodyBold: CGFloat = 22 - 18
    static let body: CGFloat = 24 - 18
    static let button: CGFloat = 19 - 16
    static let caption: CGFloat = 18 - 14
}

// MARK: - Text Style

extension Text {

    func titleStyle() -> some View {
        self
            .font(.appTitle)
            .foregroundStyle(Color(.customBlack))
            .lineSpacing(AppLineSpacing.title)
    }

    func subtitleBoldStyle() -> some View {
        self
            .font(.appSubtitleBold)
            .lineSpacing(AppLineSpacing.subtitle)
            .foregroundStyle(.customBlack)
    }

    func subtitleStyle() -> some View {
        self
            .font(.appSubtitle)
            .lineSpacing(AppLineSpacing.subtitle)
            .foregroundStyle(.customBlack)
    }

    func bodyBoldStyle() -> some View {
        self
            .font(.appBodyBold)
            .lineSpacing(AppLineSpacing.bodyBold)
            .foregroundStyle(.customBlack)
    }

    func bodyStyle() -> some View {
        self
            .font(.appBody)
            .lineSpacing(AppLineSpacing.body)
            .foregroundStyle(.customBlack)
    }

    func buttonStyle() -> some View {
        self
            .font(.appButton)
            .lineSpacing(AppLineSpacing.button)
            .foregroundStyle(.customBlack)
    }

    func captionBoldStyle() -> some View {
        self
            .font(.appCaptionBold)
            .lineSpacing(AppLineSpacing.caption)
            .foregroundStyle(.customBlack)
    }

    func captionStyle() -> some View {
        self
            .font(.appCaption)
            .lineSpacing(AppLineSpacing.caption)
            .foregroundStyle(.customBlack)
    }
}
