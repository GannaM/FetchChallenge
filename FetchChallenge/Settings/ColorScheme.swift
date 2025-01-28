//
//  ColorScheme.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/27/25.
//

import SwiftUI

enum AppColorScheme: Int, CaseIterable {
    case light
    case dark
    case automatic
    
    var name: String {
        switch self {
        case .light: String(localized: "Light", comment: "Light color scheme title")
        case .dark: String(localized: "Dark", comment: "Dark color scheme title")
        case .automatic: String(localized: "Automatic", comment: "Automatic color scheme title")
        }
    }
    
    @MainActor
    func apply() {
        let userInterfaceStyle: UIUserInterfaceStyle = switch self {
        case .automatic: UIScreen.main.traitCollection.userInterfaceStyle
        case .light: .light
        case .dark: .dark
        }

        for window in UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows })
            .joined()
        {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    }
}

extension AppColorScheme {
    var systemValue: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .automatic: nil
        }
    }
}
