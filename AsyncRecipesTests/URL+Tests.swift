//
//  URL+Tests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import Testing

@testable import AsyncRecipes

struct URLExtensionTests {
    @Test private func asYoutubeEmbedded() async throws {
        let expected = URL(string: "https://www.youtube.com/embed/6R8ffRRJcrg")!
        let subject = Recipe.mock().youtubeUrl.flatMap(URL.init(string:))?.asYoutubeEmbeded
        #expect(subject == expected)
    }
}
