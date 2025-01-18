//
//  ImageView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import SwiftUI

struct ImageView: View {
    private let imageCache: ImageCache

    init(imageName: String) {
        self.imageCache = ImageCache(imageName: imageName)
    }

    var body: some View {
        AsyncTaskView(task: imageCache.loadImage) { image, _ in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } errorView: { _, _, reloadTask in
            BlankAsyncTaskView.defaultErrorView(reloadTask: reloadTask)
        }
    }
}

#Preview {
    ImageView(imageName: "https://lucasassisro.vercel.app/favicon/android-chrome-192x192.png")
}
