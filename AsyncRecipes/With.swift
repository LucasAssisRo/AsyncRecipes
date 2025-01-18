//
//  With.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

func with<Value>(_ value: Value, _ block: (_ value: inout Value) -> Void) -> Value {
    var value = value
    block(&value)
    return value
}
