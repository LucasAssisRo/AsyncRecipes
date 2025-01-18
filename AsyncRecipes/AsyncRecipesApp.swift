//
//  AsyncRecipesApp.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftData
import SwiftUI

@main
struct AsyncRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            if let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
                RecipeList(url: url)
            } else {
                Text(
                    """
                    Malformed URL Error
                    Please contact support
                    """
                )
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.red)
            }
        }
    }
}
