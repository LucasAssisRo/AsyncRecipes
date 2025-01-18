//
//  RecipeListFetcherTests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import Testing

@testable import AsyncRecipes

struct RecipeListFetcherTests {
    @Test private func testSuccess() async throws {
        let successURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let subject = try await RecipeListFetcher(url: successURL).loadRecipes()
        #expect(!subject.recipes.isEmpty)
    }

    @Test private func testSuccessEmpty() async throws {
        let successURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        let subject = try await RecipeListFetcher(url: successURL).loadRecipes()
        #expect(subject.recipes.isEmpty)
    }

    @Test private func testFailure() async throws {
        let successURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        await #expect(throws: (any Error).self, performing: RecipeListFetcher(url: successURL).loadRecipes)
    }
}
