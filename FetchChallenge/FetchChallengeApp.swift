//
//  FetchChallengeApp.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import SwiftUI

@main
struct FetchChallengeApp: App {
    @StateObject var appSettings: AppSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            RecipesView(viewModel: RecipesViewModel())
                .environmentObject(appSettings)
                .onAppear { appSettings.colorScheme.apply() }
        }
    }
}
