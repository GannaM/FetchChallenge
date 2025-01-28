//
//  SettingsView.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/27/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        List {
            Section("Color scheme") {
                ForEach(AppColorScheme.allCases, id: \.self) { scheme in
                    HStack {
                        Text(scheme.name)
                        Spacer()

                        if appSettings.colorScheme == scheme {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        appSettings.updateColorScheme(scheme)
                    }
                    .sensoryFeedback(.selection, trigger: appSettings.colorScheme)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings())
}
