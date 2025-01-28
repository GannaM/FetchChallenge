//
//  AppSettings.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/27/25.
//

import SwiftUI

@MainActor
final class AppSettings: ObservableObject {
    @AppStorage("colorScheme") private(set) var colorScheme: AppColorScheme = .automatic
 
    func updateColorScheme(_ scheme: AppColorScheme) {
        colorScheme = scheme
        colorScheme.apply()
    }
}
