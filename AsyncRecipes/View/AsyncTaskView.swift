//
//  AsyncTaskView.swift
//  AsyncRecipes
//
//  Created by Lucas Assis Rodrigues on 1/17/25.
//

import OSLog
import SwiftUI

struct AsyncTaskView<Content, ContentView: View, ErrorView: View, LoadingView: View>: View {
    var logger: Logger
    var task: () async throws -> Content
    var contentView: (_ content: Content, _ reloadTask: @Sendable @escaping () -> Void) -> ContentView
    var errorView:
        (
            _ error: any Error,
            _ previousContent: Content?,
            _ reloadTask: @Sendable @escaping () -> Void
        ) -> ErrorView
    var loadingView: (_ previousContent: Content?) -> LoadingView

    @State private var state = StateMachine()
    @State private var taskId = UUID()

    init(
        logger: Logger = Logger(subsystem: "AsyncRecipes", category: "AsyncTaskView"),
        task: @escaping () async throws -> Content,
        @ViewBuilder contentView: @escaping (
            _ content: Content,
            _ reloadTask: @Sendable @escaping () -> Void
        ) -> ContentView,
        @ViewBuilder errorView: @escaping (
            _ error: any Error,
            _ previousContent: Content?,
            _ reloadTask: @Sendable @escaping () -> Void
        ) -> ErrorView,
        @ViewBuilder loadingView: @escaping (_ previousContent: Content?) -> LoadingView
    ) {
        self.logger = logger
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
                errorView(error, content, reloadTask)
            case let .loading(previousContent: content):
                loadingView(content)
            }
        }
        .task(id: taskId) {
            await performTask()
        }
    }

    func performTask() async {
        state.startLoading()
        do {
            let content = try await task()
            state.receive(content: content)
        } catch {
            state.receive(error: error)
            logger.error("\(error.localizedDescription)")
        }
    }

    func reloadTask() {
        taskId = UUID()
    }
}

typealias BlankAsyncTaskView = AsyncTaskView<Void, EmptyView, EmptyView, EmptyView>

extension AsyncTaskView {
    @ViewBuilder
    static func defaultErrorView(reloadTask: @Sendable @escaping () -> Void) -> some View {
        Button(action: reloadTask) {
            Label("Something went wrong! Tap to try again", systemImage: "exclamationmark.triangle.fill")
        }
        .foregroundStyle(.red)
    }

    init(
        task: @escaping () async throws -> Content,
        @ViewBuilder contentView: @escaping (
            _ content: Content,
            _ reloadTask: @Sendable @escaping () -> Void
        ) -> ContentView,
        @ViewBuilder errorView: @escaping (
            _ error: any Error,
            _ previousContent: Content?,
            _ reloadTask: @Sendable @escaping () -> Void
        ) -> ErrorView
    )
    where
        LoadingView == ProgressView<EmptyView, EmptyView>
    {
        self.init(task: task, contentView: contentView, errorView: errorView) { _ in
            ProgressView()
        }
    }
}

extension AsyncTaskView {
    typealias StateMachine = AsyncRecipes.StateMachine<Content, any Error>
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
        } errorView: { _, _, reloadTask in
            BlankAsyncTaskView.defaultErrorView(reloadTask: reloadTask)
        }
        AsyncTaskView {
            try await Task {
                try await Task.sleep(for: .seconds(2))
                throw NSError(domain: "", code: 1)
            }
            .value
        } contentView: { content, _ in
            Color.green
        } errorView: { _, _, reloadTask in
            BlankAsyncTaskView.defaultErrorView(reloadTask: reloadTask)
        }
    }
    .padding()

}
