//
//  AsyncRecipesTests.swift
//  AsyncRecipesTests
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import Testing
@testable import AsyncRecipes

struct WithTests{
    @Test func updateInline() async throws {
        struct Test: Equatable {
            var foo: Int = .min
        }
        
        let expected = Test(foo: 1)
        let subject = with(Test()) { subject in
            subject.foo = 1
        }
        
        #expect(subject == expected)
    }
}
