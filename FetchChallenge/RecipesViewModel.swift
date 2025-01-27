//
//  RecipesViewModel.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation
import Combine

enum ViewState {
    case loading
    case data
    case error
}

@MainActor
final class RecipesViewModel: ObservableObject {
    
    private let apiService: APIService
    
    @Published private(set) var viewState: ViewState = .loading
    @Published private(set) var allRecipes: [Recipe] = [] {
        didSet {
            // Get all possible cuisines for the Filter menu. Sort them by name
            let cuisines = Array(Set(allRecipes.map { $0.cuisine }).sorted(by: { $0 < $1 }))
            self.cuisineList = cuisines
        }
    }
    
    @Published private(set) var cuisineList: [String] = []
    
    @Published private(set) var filteredRecipes: [Recipe] = []
    
    @Published var selectedCuisine: String?
    @Published var searchText: String = ""
    
    init(apiService: APIService = APIServiceImp()) {
        self.apiService = apiService
        
        Publishers.CombineLatest3($allRecipes, $selectedCuisine, $searchText).map { allRecipes, selectedCuisine, searchText in
            let filtered = Self.filter(allRecipes, by: selectedCuisine)
            let searched = Self.filter(filtered, by: searchText)
            return searched
        }
        .assign(to: &$filteredRecipes)
    }
    
    func loadData() async {
        do {
            let recipes = try await apiService.getRecipes()
            self.allRecipes = recipes
            viewState = .data
        } catch {
            viewState = .error
        }
    }
    
    func reload() {
        viewState = .loading
        Task {
            await loadData()
        }
    }
    
    private static func filter(_ recipes: [Recipe], by cuisine: String?) -> [Recipe] {
        guard let cuisine else { return recipes }
        
        let filter = cuisine.lowercased()
        let filteredRecipes = recipes.filter { $0.cuisine.lowercased() == filter }
        
        return filteredRecipes
    }
    
    private static func filter(_ recipes: [Recipe], by searchText: String) -> [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        
        let lowerCaseSearchText = searchText.lowercased()
        let searchedRecipes: [Recipe] = recipes.filter { recipe in
            recipe.name.lowercased().contains(lowerCaseSearchText) ||
            recipe.cuisine.lowercased().contains(lowerCaseSearchText)
        }
        
        return searchedRecipes
    }
}
