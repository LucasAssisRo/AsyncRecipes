//
//  With.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

/// Returns a copy of the value passed with the modifications performed on the provided block.
/// - Parameters:
///     - value: Value to be modified.
///     - block: Perfoms the modifications on the provided value.
///
/// Useful to avoid using IIFEs when initializing properties and keeping configuration code organized.
///
func with<Value>(_ value: Value, _ block: (inout Value) -> Void) -> Value {
    var value = value
    block(&value)
    return value
}
