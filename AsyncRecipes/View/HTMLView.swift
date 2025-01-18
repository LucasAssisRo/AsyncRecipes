//
//  HTMLView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import UIKit
import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let url: URL
    let html: String
    
    private let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: url)
    }
}

#Preview {
    HTMLView(url: URL(string: "https://test.io")!, html: "<h1 style='font-size:20rem'>Test")
}
