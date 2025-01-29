//
//  ContentViewTests.swift
//  FetchChallengeTests
//
//  Created by Anna Myshliakova on 1/28/25.
//

import Testing
@testable import FetchChallenge

@MainActor
struct ContentViewTests {

    @Test func loadDataSuccess() async throws {
        let service = APIServiceImp(network: NetworkGoodMock())
        let vm = RecipesViewModel(apiService: service)
        
        #expect(vm.viewState == .loading)
        
        await vm.loadData()
        
        #expect(vm.viewState == .data)
    }
    
    @Test func loadDataFailure() async throws {
        let service = APIServiceImp(network: NetworkBadMock())
        let vm = RecipesViewModel(apiService: service)
        
        #expect(vm.viewState == .loading)
        
        await vm.loadData()
        
        #expect(vm.viewState == .error)
    }
    
    @Test func loadDataEmpty() async throws {
        let service = APIServiceImp(network: NetworkEmptyMock())
        let vm = RecipesViewModel(apiService: service)
        
        #expect(vm.viewState == .loading)
        
        await vm.loadData()
        
        #expect(vm.viewState == .data)
        #expect(vm.allRecipes.isEmpty)
    }
    
    @Test func filterRecipes() async throws {
        let service = APIServiceImp(network: NetworkGoodMock())
        let vm = RecipesViewModel(apiService: service)
        await vm.loadData()
        
        #expect(vm.filteredRecipes.count == 2)
        
        vm.selectedCuisine = "American"
        
        #expect(vm.filteredRecipes.count == 1)
        #expect(vm.filteredRecipes[0].cuisine == "American")
    }
    
    @Test func searchRecipes() async throws {
        let service = APIServiceImp(network: NetworkGoodMock())
        let vm = RecipesViewModel(apiService: service)
        await vm.loadData()
        
        vm.searchText = "Apam"
        
        #expect(vm.filteredRecipes.allSatisfy({ recipe in
            recipe.name.contains("Apam")
        }))
    }

}
