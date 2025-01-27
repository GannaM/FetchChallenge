//
//  RecipeCellView.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import SwiftUI

struct RecipeCellView: View {
    var recipe: Recipe
    
    var body: some View {
        HStack(spacing: 10) {
            image
            detail
            Spacer(minLength: 0)
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
    
    private var image: some View {
        CachedImage(url: recipe.photoUrlSmall)
            .frame(width: 100, height: 100)
            .cornerRadius(6)
    }
    
    private var detail: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.headline)
                .lineLimit(2)
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}

#Preview {
    RecipeCellView(recipe: .sample)
}

private extension Recipe {
    static var sample: Recipe {
        .init(
            id: UUID(),
            cuisine: "American",
            name: "Burger",
            photoUrlLarge: nil,
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceUrl: nil,
            youtubeUrl: nil
        )
    }
}
