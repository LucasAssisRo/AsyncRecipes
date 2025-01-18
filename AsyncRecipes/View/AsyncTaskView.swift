//
//  AsyncTaskView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import SwiftUI

struct AsyncTaskView<Content, ContentView: View, ErrorView: View, LoadingView: View>: View {
    var task: () async throws -> Content
    var contentView: (_ content: Content, _ reloadTask: @Sendable @escaping () -> Void) -> ContentView
    var errorView: (_ error: any Error, _ previousContent: Content?) -> ErrorView
    var loadingView: (_ previousContent: Content?) -> LoadingView

    @State private var state: StateMachine = .loading()
    @State private var taskId = UUID()

    init(
        task: @escaping () async throws -> Content,
        @ViewBuilder
        contentView: @escaping (_ content: Content, _ reloadTask: @Sendable @escaping () -> Void) -> ContentView,
        @ViewBuilder
        errorView: @escaping (_ error: any Error, _ previousContent: Content?) -> ErrorView,
        @ViewBuilder
        loadingView: @escaping (_ previousContent: Content?) -> LoadingView
    ) {
        self.task = task
        self.contentView = contentView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    var body: some View {
        Group {
            switch state {
            case let .content(content):
                contentView(content, reloadTask)
            case let .error(error, previousContent: content):
                Button(action: reloadTask) {
                    errorView(error, content)
                }
                .foregroundStyle(.red)
            case let .loading(previousContent: content):
                loadingView(content)
            }
        }
        .task(id: taskId) {
            await performTask()
        }
    }

    func performTask() async {
        state = .loading(previousContent: state.content)
        do {
            let content = try await task()
            state = .content(content)
        } catch {
            state = .error(error, previousContent: state.content)
        }
    }

    func reloadTask() {
        taskId = UUID()
    }
}

extension AsyncTaskView {
    init(
        task: @escaping () async throws -> Content,
        @ViewBuilder
        contentView: @escaping (_ content: Content, _ reloadTask: @Sendable @escaping () -> Void) -> ContentView
    )
    where
        LoadingView == ProgressView<EmptyView, EmptyView>,
        ErrorView == Label<Text, Image>
    {
        self.task = task
        self.contentView = contentView
        self.errorView = { _, _ in
            Label("Something went wrong!", systemImage: "exclamationmark.triangle.fill")
        }
        self.loadingView = { _ in ProgressView() }
    }
}

extension AsyncTaskView {
    enum StateMachine {
        case content(_ content: Content)
        case error(_ error: any Error, previousContent: Content? = nil)
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
}

#Preview {
    VStack {
        AsyncTaskView {
            try await Task {
                try await Task.sleep(for: .seconds(2))
                return 1
            }
            .value
        } contentView: { content, _ in
            Color.green
        }
        AsyncTaskView {
            try await Task {
                try await Task.sleep(for: .seconds(2))
                throw NSError(domain: "", code: 1)
            }
            .value
        } contentView: { content, _ in
            Color.green
        }
    }
    .padding()

}
