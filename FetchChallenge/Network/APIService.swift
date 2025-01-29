//
//  APIService.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

protocol APIService: Sendable {
    func getRecipes() async throws -> [Recipe]
}

final class APIServiceImp: APIService {
    private let network: Network
    
    init(network: Network = NetworkImp()) {
        self.network = network
    }
    
    func getRecipes() async throws -> [Recipe] {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
//        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
//        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        
        let url = URL(string: urlString)!
        let response: RecipeResponse = try await network.requestObject(url)
        return response.recipes ?? []
    }
}
