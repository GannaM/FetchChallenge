//
//  Recipe.swift
//  FetchChallenge
//
//  Created by Anna Myshliakova on 1/25/25.
//

import Foundation

struct RecipeResponse: Decodable {
    var recipes: [Recipe]?
}

struct Recipe: Decodable, Identifiable, Hashable {
    var id: UUID
    var cuisine: String
    var name: String
    var photoUrlLarge: URL?
    var photoUrlSmall: URL?
    var sourceUrl: URL?
    var youtubeUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
