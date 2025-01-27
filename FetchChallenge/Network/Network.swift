//
//  Network.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

protocol Network: Sendable {
    func requestObject<T: Decodable>(_ url: URL) async throws -> T
}

final class NetworkImp: Network {
    private let decoder = JSONDecoder()
    private let session: URLSession = .shared
    
    func requestObject<T: Decodable>(_ url: URL) async throws -> T {
        let data = try await requestData(url)
        return try decoder.decode(T.self, from: data)
    }
    
    private func requestData(_ url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           200..<300 ~= httpResponse.statusCode {
            return data
        } else {
            throw APIError.badResponse
        }
    }
    
//    private func fetchData() async throws -> Data {
//        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        if let httpResponse = response as? HTTPURLResponse,
//           200..<300 ~= httpResponse.statusCode {
//            return data
//        } else {
//            throw APIError.badResponse
//        }
//    }
//    
//    func getRecipes() async throws -> [Recipe] {
//        let responseData = try await fetchData()
//        let data = try decoder.decode(RecipeResponse.self, from: responseData)
//        return data.recipes ?? []
//    }
    
//    func requestObject<T: Decodable>(_ url: URL) async throws -> T {
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        if let httpResponse = response as? HTTPURLResponse,
//           200..<300 ~= httpResponse.statusCode {
//            return try self.decoder.decode(T.self, from: data)
//        } else {
//            throw APIError.badResponse
//        }
//    }
}
