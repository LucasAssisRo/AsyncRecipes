//
//  StateMachine.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

/// Represents the possible states of an async task while holding the contents of previous iterations of said task.
enum StateMachine<Content, Error: Swift.Error> {
    /// Initializes state machine on correct state given initial parameters.
    /// - Parameters:
    ///   - content: Initial content value.
    ///   - error: Initial error value.
    ///
    init(content: Content? = nil, error: Error? = nil) {
        switch (content, error) {
        case (nil, nil): self = .loading(previousContent: nil)
        case let (content?, nil): self = .content(content)
        case let (content, error?): self = .error(error, previousContent: content)
        }
    }

    /// Task completed and returned a valid value.
    /// - parameter content: Value returned by task.
    ///
    case content(_ content: Content)

    /// Task completed with error.
    /// - parameter error: Error thrown by task.
    /// - parameter content: Last valid content value received by state machine if exists.
    ///
    case error(_ error: Error, previousContent: Content? = nil)

    /// Task is still being performed.
    /// - parameter content: Last valid content value received by state machine if exists.
    ///
    case loading(previousContent: Content? = nil)

    /// Current valid content value stored on state machine.
    /// > Important: A non `nil` value in this property doesn't mean the current machine state is `.content`.
    ///
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

extension StateMachine {
    /// Transitions machine to content state.
    /// - parameter content: Content value returned by task.
    ///
    mutating func receive(content: Content) {
        self = .content(content)
    }

    /// Transitions machine to error state while keeping track of previous stored content.
    /// - Parameter error: Error thrown by task.
    ///
    mutating func receive(error: Error) {
        self = .error(error, previousContent: content)
    }

    /// Transitions machine to loading state while keeping track of previous stored content.
    mutating func startLoading() {
        self = .loading(previousContent: content)
    }
}

// MARK: - StateMachine + Equatable

extension StateMachine: Equatable where Content: Equatable, Error: Equatable {}
