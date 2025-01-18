//
//  ImageCache.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import OSLog
import SwiftUI

final class ImageCache {
    let imageName: String
    let fileManager: FileManager
    let urlSession: URLSession
    let logger: Logger

    var image: UIImage?

    init(
        imageName: String,
        fileManager: FileManager = .default,
        urlSession: URLSession = .shared,
        logger: Logger = .init(subsystem: "AsyncRecipes", category: "ImageCache")
    ) {
        self.imageName = imageName
        self.fileManager = fileManager
        self.urlSession = urlSession
        self.logger = logger
    }

    func loadImage() async throws -> UIImage {
        if let uiImage = image {
            return uiImage
        }

        do {
            if let uiImage = try await loadImageFromFile() {
                image = uiImage
                return uiImage
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }

        do {
            if let uiImage = try await loadImageFromRemote() {
                Task { await saveRemoteImageToDisk(image: uiImage) }
                image = uiImage
                return uiImage
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }

        throw Error.failedToCreateUIImage
    }
}

extension ImageCache {
    enum Error: Swift.Error {
        case failedToCreateUIImage
    }

    var documetsDirectory: URL {
        get throws {
            try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
    }

    var imageFileURL: URL {
        get throws {
            try URL(
                fileURLWithPath: imageName.replacingOccurrences(of: "/", with: "_")
                    .replacingOccurrences(of: ":", with: "_")
                    .replacingOccurrences(of: ".", with: "_"),
                relativeTo: documetsDirectory
            )
                .appendingPathExtension("png")
        }
    }

    private func loadImageFromFile() async throws -> UIImage? {
        let data = try await urlSession.data(from: imageFileURL).0
        return UIImage(data: data)
    }

    private func loadImageFromRemote() async throws -> UIImage? {
        guard let imageURL = URL(string: imageName) else { return nil }
        let data = try await urlSession.data(from: imageURL).0
        return UIImage(data: data)
    }

    private func saveRemoteImageToDisk(image: UIImage) async {
        do {
            guard let imageData = image.pngData() else { return }
            try imageData.write(to: imageFileURL)
        } catch {
            logger.error("\(error.localizedDescription), \((try? self.imageFileURL.absoluteString) ?? "nil")")
        }
    }
}
