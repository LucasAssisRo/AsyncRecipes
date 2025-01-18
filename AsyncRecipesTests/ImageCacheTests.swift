//
//  ImageCacheTests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import Testing
import UIKit

@testable import AsyncRecipes

@MainActor
final class ImageCacheTests {
    private let imageCache = ImageCache(imageName: "https://lucasassisro.vercel.app/favicon/android-chrome-192x192.png")

    deinit {
        try! imageCache.fileManager.removeItem(at: imageCache.documentsDirectory)
    }

    @Test private func imageFileURL() async throws {
        let documents = try imageCache.documentsDirectory
        let expected = documents.appending(
            path: "https___lucasassisro_vercel_app_favicon_android-chrome-192x192_png.png"
        )
        let subject = try imageCache.imageFileURL
        #expect(subject.absoluteString == expected.absoluteString)
    }

    @Test private func loadImage() async throws {
        let subject = try await imageCache.loadImage()
        #expect(imageCache.image! == subject)
        
        _ = await imageCache.saveImageToDiskTask!.result
        
        let imageFromFile = try await imageCache.loadImageFromFile()!
        #expect(imageCache.image!.pngData()! == imageFromFile.pngData()!)
    }

    @Test private func loadImageFromRemote() async throws {
        let subject = try await imageCache.loadImageFromRemote()
        #expect(subject != nil)
    }

    @Test private func loadImageFromFile() async throws {
        let data = try await imageCache.urlSession.data(from: URL(string: imageCache.imageName)!).0
        await imageCache.saveRemoteImageToDisk(image: UIImage(data: data)!)
        
        let subject = try await imageCache.loadImageFromFile()
        #expect(subject != nil)
    }
}
