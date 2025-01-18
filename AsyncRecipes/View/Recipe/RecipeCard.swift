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
        Group {
            HStack {
                if let photoUrlSmall = recipe.photoUrlSmall {
                    ImageView(imageName: photoUrlSmall)
                        .frame(width: 80, height: 80)
                        .roundedCorners()
                }
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .roundedCorners()
    }
}

#Preview {
    RecipeCard(recipe: .mock())
        .padding()
}
