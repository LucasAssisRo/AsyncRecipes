//
//  RecipeList.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftData
import SwiftUI

struct RecipeList: View {
    @State private var selectedRecipe: Recipe?

    let url: URL
    let decoder = with(JSONDecoder()) { decoder in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    var body: some View {
        NavigationStack {
            AsyncTaskView(task: loadRecipes) { response, reloadTask in
                if case let recipes = response.recipes,!recipes.isEmpty {
                    List(response.recipes) { recipe in
                        NavigationLink {
                            RecipeDetail(recipe: recipe)
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .foregroundStyle(.primary)
                        .shadow(radius: 8)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .refreshable(action: reloadTask)
                } else {
                    Button(
                        "No recipes found. Tap to try again",
                        systemImage: "exclamationmark.triangle.fill",
                        action: reloadTask
                    )
                }
            }
            .navigationTitle("Recipes")
        }
    }

    func toggleSelectedRecipe(with recipe: Recipe) {
        if selectedRecipe == recipe {
            selectedRecipe = nil
        } else {
            selectedRecipe = recipe
        }
    }

    func loadRecipes() async throws -> RecipesResponse {
        try await decoder.decode(
            RecipesResponse.self,
            from: URLSession.shared.data(from: url).0
        )
    }

}

#Preview {
    TabView {
        Tab("Success", systemImage: "star") {
            RecipeList(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
        }
        Tab("Empty", systemImage: "rectangle.portrait") {
            RecipeList(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!)
        }
        Tab("Failure", systemImage: "exclamationmark.shield") {
            RecipeList(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!)
        }
    }
}
