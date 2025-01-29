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

final class NetworkImp: Network {
    private let decoder = JSONDecoder()
    private let session: URLSession = .shared
    
    func requestObject<T: Decodable>(_ url: URL) async throws -> T {
        let data = try await requestData(url)
        return try decoder.decode(T.self, from: data)
    }
    
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
