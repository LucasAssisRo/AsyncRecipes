//
//  RecipesResponse.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

struct RecipesResponse {
    let recipes: [Recipe]
}

extension RecipesResponse {
    static var mock: RecipesResponse {
        .init(
            recipes: (0...4).map { offset in
                .mock(name: "Recipe \(offset)")
            }
        )
    }
}
// MARK: - RecipesResponse + Decodable

extension RecipesResponse: Decodable {}

// MARK: - RecipesResponse + Equatable

extension RecipesResponse: Equatable {}

// MARK: - RecipesResponse + Hashable

extension RecipesResponse: Hashable {}
