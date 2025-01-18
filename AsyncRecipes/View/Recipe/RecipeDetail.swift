//
//  RecipeDetail.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe

    private var youtubeEmbedUrl: URL? {
        recipe.youtubeUrl.flatMap(URL.init(string:))?.asYoutubeEmbeded
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = recipe.photoUrlLarge.flatMap(URL.init(string:)) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .roundedCorners()
                    .padding()
                }
                if let youtubeEmbedUrl {
                    HTMLView(url: youtubeEmbedUrl)
                        .frame(maxWidth: .infinity, idealHeight: 200, maxHeight: 400)
                        .roundedCorners()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(recipe.name)
                        .fontWeight(.semibold)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .fontWeight(.thin)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetail(recipe: .mock())
    }
}
