//
//  RecipesViewModel.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

enum ViewState {
    case loading
    case data
    case empty
    case error
}

@MainActor
final class RecipesViewModel: ObservableObject {
    
    private let apiService: APIService
    
    @Published private(set) var viewState: ViewState = .loading
    @Published private(set) var recipes: [Recipe] = []
    
    init(apiService: APIService = APIServiceImp()) {
        self.apiService = apiService
    }
    
    func loadData() async {
        do {
            let recipes = try await apiService.getRecipes()
            self.recipes = recipes
            viewState = recipes.isEmpty ? .empty : .data
        } catch {
            viewState = .error
        }
    }
}
