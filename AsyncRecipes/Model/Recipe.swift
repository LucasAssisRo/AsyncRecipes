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
