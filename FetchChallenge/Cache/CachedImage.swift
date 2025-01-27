//
//  CachedImage.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/26/25.
//

import SwiftUI

fileprivate enum ImageState {
    case loading
    case loaded(UIImage)
    case failed
}

struct CachedImage: View {
    var urlString: String?
    
    @Environment(\.imageCacheService) private var imageCacheService: ImageCacheService
    @State private var imageState: ImageState = .loading
    
    var body: some View {
        content
            .onAppear {
                loadImage()
            }
    }
    
    private var content: some View {
        VStack {
            switch imageState {
            case .loading:
                loadingView
            case .loaded(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
            case .failed:
                errorView
            }
        }
    }
    
    private var loadingView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            ProgressView()
        }
    }
    
    private var errorView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "photo.badge.exclamationmark.fill")
        }
    }
    
    private func loadImage() {
        guard let urlString else {
            imageState = .failed
            return
        }
        
        Task { @MainActor in
            do {
                let image = try await imageCacheService.getImage(for: urlString)
                imageState = .loaded(image)
            } catch {
                imageState = .failed
            }
        }
    }
}

#Preview {
    CachedImage(urlString: "nil")
}
