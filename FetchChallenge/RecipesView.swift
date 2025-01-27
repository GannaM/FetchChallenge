//
//  ContentView.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import SwiftUI

struct RecipesView: View {
    @StateObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        settingsButton
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        filterButton
                    }
                }
        }
        .ignoresSafeArea(edges: [.bottom])
        .task {
            await viewModel.loadData()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .data:
            loadedView
        case .empty:
            emptyView
        case .error:
            errorView
        }
    }
    
    private var errorView: some View {
        VStack {
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text("Oops! Something went wrong.\nPlease, try again later!")
                .multilineTextAlignment(.center)
            Button {
                // TODO: handle reloading data
                // viewModel.reload()
            } label: {
                Text("Reload", comment: "Reload button label")
            }
            .padding()
        }
    }
    
    private var emptyView: some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text("No albums found")
                .bold()
            Text("Try narrowing down your search")
                .multilineTextAlignment(.center)
        }
    }
    
    private var loadedView: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                RecipeCellView(recipe: recipe)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // TODO: handle taps
                        // viewModel.onRecipeTap(recipe)
                    }
                    .padding(.trailing, -16)
            }
        }
        .listStyle(.grouped)
        .refreshable {
            await viewModel.loadData()
        }
    }
    
    private var filterButton: some View {
        Menu {
            // TODO: add menu data
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
    
    private var settingsButton: some View {
        Button {
//            viewModel.showSettings = true
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private var allFilterText: String {
        String(localized: "All", comment: "Represents all albums filter option")
    }
    
    private var searchPromptText: String {
        String(localized: "Search", comment: "Placeholder text for search field")
    }
}

#Preview {
    RecipesView(viewModel: .init())
}
