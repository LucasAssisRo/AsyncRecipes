//
//  ImageView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import SwiftUI

struct ImageView: View {
    private var imageCache: ImageCache

    init(imageName: String) {
        self.imageCache = ImageCache(imageName: imageName)
    }

    var body: some View {
        AsyncTaskView(task: imageCache.loadImage) { image, _ in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    ImageView(imageName: "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
}
