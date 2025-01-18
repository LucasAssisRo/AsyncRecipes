//
//  RecipeCard.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
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
}

#Preview {
    RecipeCard(recipe: .mock())
}
