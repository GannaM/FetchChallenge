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
    
    init(network: Network = NetworkImp(), cache: URLCache = URLCache()) {
        self.network = network
        self.cache = cache
    }
    
    func getImage(for url: URL) async throws -> UIImage {
        let data = try await getImageData(for: url)
        guard let image = UIImage(data: data) else { throw ImageError.badImageData }
        
        return image
    }
    
    private func getImageData(for url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data {
            return data
        }
        
        let result = try await network.requestData(url)
        
        cache.storeCachedResponse(.init(response: result.1, data: result.0), for: request)
        
        return result.0
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
