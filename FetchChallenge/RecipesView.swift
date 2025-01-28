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
                .searchable(text: $viewModel.searchText, placement: .automatic, prompt: searchPromptText)
        }
        .ignoresSafeArea(edges: [.bottom])
        .task {
            await viewModel.loadData()
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
        
        .animation(.easeInOut, value: viewModel.viewState)
        .animation(.easeInOut, value: viewModel.filteredRecipes.isEmpty)
        .confirmationDialog("Reference",
                            isPresented: viewModel.isConfirmationSheetPresented,
                            presenting: viewModel.selectedRecipe,
                            actions: { recipe in
            
            if let youtubeUrl = recipe.youtubeUrl {
                Button("YouTube") {
                    viewModel.open(url: youtubeUrl)
                }
            }
            
            if let sourceUrl = recipe.sourceUrl {
                Button("Source") {
                    viewModel.open(url: sourceUrl)
                }
            }
            
        }, message: { recipe in
            Text(recipe.name)
        })
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .data:
            if viewModel.filteredRecipes.isEmpty {
                emptyView
            } else {
                loadedView
            }
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
                 viewModel.reload()
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
            Text("Oh-oh! No recipes found.")
                .bold()
        }
    }
    
    private var loadedView: some View {
        List {
            ForEach(viewModel.filteredRecipes) { recipe in
                RecipeCellView(recipe: recipe)
                    .padding(.trailing, -16)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.onRecipeTap(recipe)
                    }
            }
        }
        .listStyle(.grouped)
        .refreshable {
            await viewModel.loadData()
        }
    }
    
    private var filterButton: some View {
        Menu {
            // Nil represents All (no filter selected)
            ForEach([nil] + viewModel.cuisineList, id: \.self) { cuisine in
                Button {
                    viewModel.selectedCuisine = cuisine
                } label: {
                    Text(cuisine ?? allFilterText)

                    if viewModel.selectedCuisine == cuisine {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: viewModel.selectedCuisine == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
    }
    
    private var settingsButton: some View {
        Button {
            viewModel.showSettings = true
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private var allFilterText: String {
        String(localized: "All", comment: "Represents all recipes filter option")
    }
    
    private var searchPromptText: String {
        String(localized: "Search", comment: "Placeholder text for search field")
    }
}

#Preview {
    RecipesView(viewModel: .init())
}
