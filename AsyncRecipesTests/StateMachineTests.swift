//
//  StateMachineTests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import Testing

@testable import AsyncRecipes

struct StateMachineTests {
    private struct EquatableError: Error, Equatable, ExpressibleByStringInterpolation {
        let value: String

        init(stringLiteral value: String) {
            self.value = value
        }
    }

    private typealias Subject = StateMachine<Int, EquatableError>

    @Test private func initialValues() {
        #expect(Subject() == .loading())
        #expect(Subject(content: 1) == .content(1))
        #expect(Subject(error: "") == .error(""))
        #expect(Subject(content: 1, error: "") == .error("", previousContent: 1))
    }

    @Test(
        arguments: [
            Subject.content(1),
            .loading(previousContent: 1),
            .error("", previousContent: 1),
        ]
    )
    private func contentAccessorExists(subject: Subject) async throws {
        let expected = 1
        #expect(subject.content == expected)
    }

    @Test(
        arguments: [
            Subject.loading(previousContent: nil),
            .error("", previousContent: nil),
        ]
    )
    private func contentAccessorDoesntExist(subject: Subject) async throws {
        let expected = Int?.none
        #expect(subject.content == expected)
    }

    @Test(
        arguments: [
            Subject.content(1),
            .content(2),
            .loading(previousContent: nil),
            .loading(previousContent: 1),
            .loading(previousContent: 2),
            .error("", previousContent: nil),
            .error("", previousContent: 1),
            .error("", previousContent: 2),
        ]
    )
    private func receiveContent(initialSubject: Subject) async throws {
        let expected = Subject.content(1)
        var subject = initialSubject
        subject.receive(content: 1)
        #expect(subject == expected)
    }

    @Test(
        arguments: [
            Subject.loading(previousContent: nil),
            .error("", previousContent: nil),
            .error("1", previousContent: nil),
        ]
    )
    private func receiveErrorNoContent(initialSubject: Subject) async throws {
        let expected = Subject.error("1")
        var subject = initialSubject
        subject.receive(error: "1")
        #expect(subject == expected)
    }

    @Test(
        arguments: [
            Subject.loading(previousContent: 1),
            .loading(previousContent: 2),
            .error("", previousContent: nil),
            .error("1", previousContent: nil),
            .error("", previousContent: 1),
            .error("1", previousContent: 2),
            .content(2),
        ]
    )
    private func receiveErrorWithContent(initialSubject: Subject) async throws {
        let expected = Subject.error("1", previousContent: 1)
        var subject = initialSubject
        subject.receive(content: 1)
        subject.receive(error: "1")
        #expect(subject == expected)
    }

    @Test(
        arguments: [
            Subject.loading(previousContent: nil),
            .error("", previousContent: nil),
            .error("1", previousContent: nil),
        ]
    )
    private func startLoadingNoContent(initialSubject: Subject) async throws {
        let expected = Subject.loading()
        var subject = initialSubject
        subject.startLoading()
        #expect(subject == expected)
    }

    @Test(
        arguments: [
            Subject.loading(previousContent: nil),
            .loading(previousContent: 1),
            .loading(previousContent: 2),
            .error("", previousContent: nil),
            .error("1", previousContent: nil),
            .error("", previousContent: 1),
            .error("1", previousContent: 2),
            .content(1),
            .content(2),
        ]
    )
    private func startLoadingWithContent(initialSubject: Subject) async throws {
        let expected = Subject.loading(previousContent: 1)
        var subject = initialSubject
        subject.receive(content: 1)
        subject.startLoading()
        #expect(subject == expected)
    }
}
