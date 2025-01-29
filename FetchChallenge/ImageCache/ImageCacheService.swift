//
//  ImageCacheService.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import SwiftUI

final class ImageCacheService: Sendable {
    private let network: Network
    private let cache: ImageCache
    
    init(network: Network = NetworkImp(), cache: ImageCache = ImageCache()) {
        self.network = network
        self.cache = cache
    }
    
    func getImage(for url: URL) async throws -> UIImage {
        if let image = await cache.getImage(for: url.absoluteString) {
            return image
        }
        
        let data = try await network.requestData(url)
        guard let image = UIImage(data: data) else { throw ImageError.badImageData }
        
        await cache.setImage(for: url.absoluteString, image: image)
        
        return image
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
