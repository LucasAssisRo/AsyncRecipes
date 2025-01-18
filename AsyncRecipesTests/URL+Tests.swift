//
//  URL+Tests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Testing
import Foundation
@testable import AsyncRecipes

struct URLExtensionTests{
    @Test func asYoutubeEmbedded() async throws {
        let expected = URL(string: "https://www.youtube.com/embed/6R8ffRRJcrg")!
        let subject  = Recipe.mock().youtubeUrl.flatMap(URL.init(string:))?.asYoutubeEmbeded
        #expect(subject == expected)
    }
}
