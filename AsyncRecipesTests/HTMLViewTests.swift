//
//  HTMLViewTests.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/18/25.
//

import Foundation
import Testing
import UIKit
import WebKit

@testable import AsyncRecipes

@MainActor
struct HTMLViewTests {
    private let coordinator = HTMLView(url: URL(string: "https://lucasassisro.vercel.app")!).makeCoordinator()

    // Must be static constant to avoid auto releasing issues coming from implementation details of WKNavigation.
    private static let navigation = WKNavigation()

    private var loadingIndicator: UIActivityIndicatorView { coordinator.loadingIndicator }
    private var webView: WKWebView { coordinator.webView }
    private var errorButton: UIButton { coordinator.errorButton }

    @Test private func coordinatorInitialState() async throws {
        #expect(!loadingIndicator.isAnimating && webView.isHidden && errorButton.isHidden)
    }

    @Test private func coordinatorStartLoading() async throws {
        coordinator.webView(webView, didStartProvisionalNavigation: Self.navigation)
        #expect(loadingIndicator.isAnimating && webView.isHidden && errorButton.isHidden)
    }

    @Test private func coordinatorSuccess() async throws {
        coordinator.webView(webView, didFinish: Self.navigation)
        #expect(!loadingIndicator.isAnimating && !webView.isHidden && errorButton.isHidden)
    }

    @Test private func coordinatorFailure() async throws {
        coordinator.webView(webView, didFail: Self.navigation, withError: NSError(domain: "", code: 1))
        #expect(!loadingIndicator.isAnimating && webView.isHidden && !errorButton.isHidden)
    }
}
