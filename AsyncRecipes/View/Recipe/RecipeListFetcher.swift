//
//  RecipeListFetcher.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation

final class RecipeListFetcher {
    let url: URL
    let urlSession: URLSession
    
    private let decoder = with(JSONDecoder()) { decoder in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    init(url: URL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }
    
    func loadRecipes() async throws -> RecipesResponse {
        try await decoder.decode(
            RecipesResponse.self,
            from: URLSession.shared.data(from: url).0
        )
    }
}
