//
//  View+.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import SwiftUI

extension View {
    func roundedCorners() -> some View {
        clipShape(.rect(cornerRadius: 8))
    }
}
