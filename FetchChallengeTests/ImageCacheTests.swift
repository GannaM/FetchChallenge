//
//  ImageCacheTests.swift
//  FetchChallengeTests
//
//  Created by Anna Myshliakova on 1/28/25.
//

import Testing
@testable import FetchChallenge
import UIKit

@Suite(.serialized) struct ImageCacheTests {
    @Test func successfullySaveImage() async throws {
        let cache = ImageCache()
        await cache.clearCache()
        
        let testImage = UIImage(systemName: "sun.min")!
        await cache.setImage(for: "test_sun", image: testImage)
        
        let cachedImage = await cache.getImage(for: "test_sun")
        #expect(cachedImage == testImage)
    }
    
    @Test func testDiskDirExist() async throws {
        let cache = ImageCache()
        await cache.clearCache()
        
        let testImage = UIImage(systemName: "sun.max")!
        await cache.setImage(for: "test_sun_max", image: testImage)
        
        let imageCacheDirURL = cache.imageCacheDirURL
        #expect(FileManager.default.fileExists(atPath: imageCacheDirURL.path()))
        
        let fileName = "\("test_sun_max".hash)"
        let imagePathURL = imageCacheDirURL.appendingPathComponent(fileName)
        #expect(FileManager.default.fileExists(atPath: imagePathURL.path()))
    }
    
    @Test func clearCache() async throws {
        let cache = ImageCache()
        await cache.clearCache()
        
        let imageKey = "test_sun_max"
        
        let image = await cache.getImage(for: imageKey)
        #expect(image == nil)
        
        let fileName = "\(imageKey.hash)"
        let imageCacheDirURL = cache.imageCacheDirURL
        let imagePathURL = imageCacheDirURL.appendingPathComponent(fileName)
        #expect(!FileManager.default.fileExists(atPath: imagePathURL.path()))
    }
}
