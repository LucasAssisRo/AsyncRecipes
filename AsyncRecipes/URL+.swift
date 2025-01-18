//
//  String+.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import Foundation

extension URL {
    var asYoutubeEmbeded: Self? {
        guard case let youtube = "youtube",
            absoluteString.contains("youtube"),
            case let watch = "watch?v=",
            absoluteString.contains("watch?v=")
        else { return nil }
        let embed = "embed/"
        return URL(string: absoluteString.replacingOccurrences(of: watch, with: embed))
    }
}
