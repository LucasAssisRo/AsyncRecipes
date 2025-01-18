//
//  RecipeCard.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    var isExpanded: Bool

    var body: some View {
        Group {
            if isExpanded {
                expanded
            } else {
                colapsed
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 8))
    }
    
    @ViewBuilder var expanded: some View {
        VStack(alignment: .leading) {
            if let url = recipe.photoUrlLarge.flatMap(URL.init(string:)) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(.rect(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.black)
                Text(recipe.cuisine)
                    .font(.title3)
                Group {
                    if let source = recipe.sourceUrl.flatMap(URL.init(string:)) {
                        Link("Recipe", destination: source)
                    }
                    if let youtube = recipe.youtubeUrl.flatMap(URL.init(string:)) {
                        Link("Video", destination: youtube)
                    }
                }
                .foregroundStyle(Color.accentColor)
            }
        }
    }
    
    @ViewBuilder var colapsed: some View {
        HStack {
            if let url = recipe.photoUrlSmall.flatMap(URL.init(string:)) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
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
    }
}

#Preview {
    VStack {
        RecipeCard(recipe: .mock(), isExpanded: false)
        RecipeCard(recipe: .mock(), isExpanded: true)
    }
    .padding()
}
