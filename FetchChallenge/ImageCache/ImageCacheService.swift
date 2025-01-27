//
//  ImageCacheService.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import SwiftUI

final class ImageCacheService: Sendable {
    private let network: Network
    private let cache: URLCache
    
    init(network: Network = NetworkImp(), cache: URLCache = .shared) {
        self.network = network
        self.cache = .shared
    }
    
    func getImage(for urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw ImageError.badURL }

        let data = try await getImageData(for: url)
        guard let image = UIImage(data: data) else { throw ImageError.badImageData }
        
        return image
    }
    
    nonisolated private func getImageData(for url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data {
            return data
        }
        
        return try await network.requestObject(url)
    }
}

extension EnvironmentValues {
    @Entry var imageCacheService: ImageCacheService = .init()
}

extension View {
    func imageCacheService(_ imageCacheService: ImageCacheService) -> some View {
        environment(\.imageCacheService, imageCacheService)
    }
}
