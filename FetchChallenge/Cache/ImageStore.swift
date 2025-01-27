//
//  ImageStore.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

final class ImageStore {
    
    var cacheDirURL: URL {
        let urlToDoc = FileManager.default.temporaryDirectory
        return urlToDoc.appending(component: "image_cache")
    }
    
    nonisolated func getImage(url: URL) -> Data? {
        let imageName = url.lastPathComponent
        let imagePathURL = cacheDirURL.appendingPathComponent(imageName)
        return try? Data(contentsOf: imagePathURL)
    }
    
    nonisolated func saveImage(url: URL, data: Data) {
        do {
            let imageName = url.lastPathComponent
            let imagePathURL = cacheDirURL.appendingPathComponent(imageName)
            try data.write(to: imagePathURL)
        } catch {
            print("Failed to save an image: \(error.localizedDescription)")
        }
    }
}
