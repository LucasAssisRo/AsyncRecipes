//
//  StateMachine.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

enum StateMachine<Content, Error: Swift.Error> {
    case content(_ content: Content)
    case error(_ error: Error, previousContent: Content? = nil)
    case loading(previousContent: Content? = nil)

    var content: Content? {
        switch self {
        case let .content(content),
            let .error(_, previousContent: content?),
            let .loading(previousContent: content?):
            content
        case .error, .loading:
            nil
        }
    }
}
