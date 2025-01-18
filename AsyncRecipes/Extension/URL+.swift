//
//  String+.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import Foundation

extension URL {
    /// Transforms youtube watch video url into a youtube embedding one.
    /// Returns `nil` if the original url is not a youtube watch video url.
    var asYoutubeEmbeded: Self? {
        guard case let youtube = "youtube",
            absoluteString.contains(youtube),
            case let watch = "watch?v=",
            absoluteString.contains(watch)
        else { return nil }
        let embed = "embed/"
        return URL(string: absoluteString.replacingOccurrences(of: watch, with: embed))
    }
}
