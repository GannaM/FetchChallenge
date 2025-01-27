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
    var url: URL?
    
    @Environment(\.imageCacheService) private var imageCacheService: ImageCacheService
    @State private var imageState: ImageState = .loading
    
    var body: some View {
        content
            .onAppear {
                loadImage()
            }
    }
    
    @ViewBuilder
    private var content: some View {
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
        guard let url else {
            imageState = .failed
            return
        }
        
        Task {
            do {
                let image = try await imageCacheService.getImage(for: url)
                imageState = .loaded(image)
            } catch {
                imageState = .failed
            }
        }
    }
}

#Preview {
    CachedImage(url: nil)
}
