//
//  RecipeList.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftData
import SwiftUI

struct RecipeList: View {
    private var recipeListFetcher: RecipeListFetcher
    @State private var selectedRecipe: Recipe?

    init(url: URL) {
        recipeListFetcher = RecipeListFetcher(url: url)
    }

    var body: some View {
        NavigationStack {
            AsyncTaskView(task: recipeListFetcher.loadRecipes) { response, reloadTask in
                if case let recipes = response.recipes, !recipes.isEmpty {
                    recipeList(recipes: recipes)
                        .refreshable(action: reloadTask)
                } else {
                    Button(
                        "No recipes found. Tap to try again",
                        systemImage: "exclamationmark.triangle.fill",
                        action: reloadTask
                    )
                }
            } errorView: { error, previousResponse, reloadTask in
                VStack {
                    let errorButton = BlankAsyncTaskView.defaultErrorView(reloadTask: reloadTask)
                    if let recipes = previousResponse?.recipes, !recipes.isEmpty {
                        recipeList(recipes: recipes)
                            .foregroundStyle(.primary)
                            .refreshable(action: reloadTask)
                            .toolbar {
                                ToolbarItem(placement: .destructiveAction) {
                                    errorButton.tint(.red)
                                }
                            }
                    } else {
                        errorButton
                    }
                }
            }
            .navigationTitle("Recipes")
        }
    }

    @ViewBuilder
    private func recipeList(recipes: [Recipe]) -> some View {
        List(recipes) { recipe in
            Group {
                if recipe.youtubeUrl != nil {
                    NavigationLink {
                        RecipeDetail(recipe: recipe)
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                } else if let sourceUrl = recipe.sourceUrl.flatMap(URL.init(string:)) {
                    Link(destination: sourceUrl) {
                        RecipeCard(recipe: recipe)
                    }
                } else {
                    RecipeCard(recipe: recipe)
                }
            }
            .foregroundStyle(.primary)
            .shadow(radius: 8)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }

    func toggleSelectedRecipe(with recipe: Recipe) {
        if selectedRecipe == recipe {
            selectedRecipe = nil
        } else {
            selectedRecipe = recipe
        }
    }
}

@available(iOS 18.0, *)
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
