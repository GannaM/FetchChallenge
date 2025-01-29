//
//  ImageCache.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/27/25.
//

import UIKit

final actor ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    nonisolated var imageCacheDirURL: URL {
        let cachesDirURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirURL.appending(component: "image_cache")
    }
    
    func getImage(for key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        if let image = getImageFromDisk(key: key) {
            cache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    func setImage(for key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
        saveImageToDisk(key: key, image: image)
    }
    
    func clearCache() {
        cache.removeAllObjects()
        do {
            if FileManager.default.fileExists(atPath: imageCacheDirURL.path()) {
                try FileManager.default.removeItem(at: imageCacheDirURL)
            }
        } catch {
            print("Failed to clear cache: \(error.localizedDescription)")
        }
    }
        
    private func saveImageToDisk(key: String, image: UIImage) {
        do {
            if !FileManager.default.fileExists(atPath: imageCacheDirURL.path()) {
                try FileManager.default.createDirectory(at: imageCacheDirURL, withIntermediateDirectories: true)
            }
            
            let fileName = "\(key.hash)"
            let imagePathURL = imageCacheDirURL.appendingPathComponent(fileName)
            let data = image.pngData()
            try data?.write(to: imagePathURL)
        } catch {
            print("Failed to save an image: \(error.localizedDescription)")
        }
    }
    
    private func getImageFromDisk(key: String) -> UIImage? {
        let fileName = "\(key.hash)"
        let imagePathURL = imageCacheDirURL.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: imagePathURL.path)
    }
}
