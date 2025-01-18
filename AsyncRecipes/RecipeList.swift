//
//  RecipeList.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftData
import SwiftUI

struct RecipeList: View {
    @State private var recipesResponse: RecipesResponse?
    @State private var selectedRecipe: Recipe?

    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    let decoder = with(JSONDecoder()) { decoder in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    var body: some View {
        NavigationStack {
            Group {
                if let recipes = recipesResponse?.recipes {
                    List(recipes) { recipe in
                        Button {
                            toggleSelectedRecipe(with: recipe)
                        } label: {
                            HStack {
                                if let url = recipe.photoUrlSmall.flatMap(URL.init(string:)) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        EmptyView()
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(.rect(cornerRadius: 8))
                                }
                                VStack(alignment: .leading) {
                                    Text(recipe.name)
                                        .font(.headline)
                                    Text(recipe.cuisine)
                                        .font(.subheadline)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(.rect(cornerRadius: 8))

                        }
                        .foregroundStyle(.primary)
                        .shadow(radius: 8)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .task {
            await loadRecipes()
        }
    }

    func toggleSelectedRecipe(with recipe: Recipe) {
        if selectedRecipe == recipe {
            selectedRecipe = nil
        } else {
            selectedRecipe = recipe
        }
    }

    func loadRecipes() async {
        do {
            let (data, _) = try await URLSession.shared.data(for: .init(url: url))
            recipesResponse = try decoder.decode(RecipesResponse.self, from: data)
        } catch {

        }
    }

}

#Preview {
    RecipeList()
}

func with<Value>(_ value: Value, _ block: (_ value: inout Value) -> Void) -> Value {
    var value = value
    block(&value)
    return value
}
