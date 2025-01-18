//
//  HTMLView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI
import UIKit
import WebKit

struct HTMLView: UIViewRepresentable {
    let url: URL

    @State var task: Task<Void, Never>?

    init(url: URL) {
        self.url = url
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIView(context: Context) -> UIView {
        context.coordinator.contentView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        let url: URL

        private(set) lazy var webView = with(WKWebView()) { webView in
            webView.navigationDelegate = self
            webView.isHidden = true
            webView.translatesAutoresizingMaskIntoConstraints = false
        }

        let loadingIndicator = with(UIActivityIndicatorView(style: .medium)) { loadingIndicator in
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.stopAnimating()
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        }
        
        private(set) lazy var errorButton = with(UIButton()) { errorButton in
            errorButton.configuration = with(UIButton.Configuration.plain()) { configuration in
                configuration.title = "Something went wrong!"
                configuration.image = UIImage(systemName: "exclamationmark.triangle.fill")
            }
            errorButton.isHidden = true
            errorButton.tintColor = .systemRed
            errorButton.translatesAutoresizingMaskIntoConstraints = false
            errorButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    loadUrl()
                },
                for: .touchUpInside)
        }

        let contentView = UIView()

        init(url: URL) {
            self.url = url
            super.init()

            contentView.addSubview(webView)
            contentView.addSubview(loadingIndicator)
            contentView.addSubview(errorButton)
            
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: contentView.topAnchor),
                webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                errorButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                errorButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
            
            loadUrl()
        }
        
        func loadUrl() {
            webView.load(URLRequest(url: url))
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loadingIndicator.startAnimating()
            errorButton.isHidden = true
            webView.isHidden = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loadingIndicator.stopAnimating()
            errorButton.isHidden = true
            webView.isHidden = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            loadingIndicator.stopAnimating()
            errorButton.isHidden = false
            webView.isHidden = true
        }
    }
}

#Preview {
    HTMLView(url: URL(string: "https://lucasassisro.vercel.app")!)
}
