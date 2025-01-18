//
//  RecipeDetail.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe
    
    @State private var youtubeHTML: String?
    
    private var youtubeEmbedUrl: URL? {
        recipe.youtubeUrl.flatMap(URL.init(string:))?.asYoutubeEmbeded
    }
    
    var body: some View {
        VStack {
            if let url = recipe.photoUrlLarge.flatMap(URL.init(string:)) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .clipped()
            }
            ScrollView {
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.black)
                    Text(recipe.cuisine)
                        .font(.title)
                        .fontWeight(.thin)
                    if let youtubeEmbedUrl, let youtubeHTML {
                        HTMLView(url: youtubeEmbedUrl, html: youtubeHTML)
                            .frame(maxWidth: .infinity, idealHeight: 200, maxHeight: 400)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            await fetchYoutubeEmbedding()
        }
    }
    
    func fetchYoutubeEmbedding() async {
        guard let youtubeEmbedUrl else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: youtubeEmbedUrl)
            youtubeHTML = String(data: data, encoding: .utf8)
        } catch {
            
        }
    }
}

#Preview {
    RecipeDetail(recipe: .mock())
}

