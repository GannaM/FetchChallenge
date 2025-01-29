//
//  Network.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

protocol Network: Sendable {
    func requestObject<T: Decodable>(_ url: URL) async throws -> T
    func requestData(_ url: URL) async throws -> Data
}

extension Network {
    func requestObject<T: Decodable>(_ url: URL) async throws -> T {
        let data = try await requestData(url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

final class NetworkImp: Network {
    private let session: URLSession = .shared
    
    func requestData(_ url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           200..<300 ~= httpResponse.statusCode {
            return data
        } else {
            throw APIError.badResponse
        }
    }
}
