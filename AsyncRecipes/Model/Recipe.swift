//
//  Recipe.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

struct Recipe {
    ///The cuisine of the recipe.
    let cuisine: String
    ///The name of the recipe.
    let name: String
    ///The URL of the recipes’s full-size photo.
    let photoUrlLarge: String?
    ///The URL of the recipes’s small photo. Useful for list view.
    let photoUrlSmall: String?
    ///The unique identifier for the receipe. Represented as a UUID.
    let uuid: String
    ///The URL of the recipe's original website.
    let sourceUrl: String?
    ///The URL of the recipe's YouTube video.
    let youtubeUrl: String?
}

extension Recipe {
    static  func mock(name: String = "Apam Balik") -> Recipe {
        .init(
            cuisine: "Malaysian",
            name: name,
            photoUrlLarge:
                "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmall:
                "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            uuid: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            sourceUrl: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        )
    }
}

// MARK: - Recipe + Identifiable

extension Recipe: Identifiable {
    var id: String { uuid }
}

// MARK: - Recipe + Decodable

extension Recipe: Decodable {}

// MARK: - Recipe + Equatable

extension Recipe: Equatable {}

// MARK: - Recipe + Hashable

extension Recipe: Hashable {}
