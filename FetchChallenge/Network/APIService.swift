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
    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    init(network: Network = NetworkImp()) {
        self.network = network
    }
    
    func getRecipes() async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: RecipeResponse = try await network.requestObject(url)
        return response.recipes ?? []
    }
}
