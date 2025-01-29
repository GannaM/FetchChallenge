//
//  ImageCache.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/27/25.
//

import UIKit

final actor ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private var cacheDirURL: URL {
        let urlToDoc = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return urlToDoc.appending(component: "image_cache")
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
        
    private func saveImageToDisk(key: String, image: UIImage) {
        do {
            if !fileManager.fileExists(atPath: cacheDirURL.path()) {
                try fileManager.createDirectory(at: cacheDirURL, withIntermediateDirectories: true)
            }
            
            let fileName = "\(key.hash)"
            let imagePathURL = cacheDirURL.appendingPathComponent(fileName)
            let data = image.pngData()
            try data?.write(to: imagePathURL)
        } catch {
            print("Failed to save an image: \(error.localizedDescription)")
        }
    }
    
    private func getImageFromDisk(key: String) -> UIImage? {
        let fileName = "\(key.hash)"
        let imagePathURL = cacheDirURL.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: imagePathURL.path)
    }
}
