//
//  RecipesResponse.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

struct RecipesResponse {
    let recipes: [Recipe]
}

// MARK: - RecipesResponse + Decodable

extension RecipesResponse: Decodable {}

// MARK: - RecipesResponse + Equatable

extension RecipesResponse: Equatable {}

// MARK: - RecipesResponse + Hashable

extension RecipesResponse: Hashable {}
