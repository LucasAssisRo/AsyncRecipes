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
    var errorView: (_ error: any Error, _ previousContent: Content?) -> ErrorView
    var loadingView: (_ previousContent: Content?) -> LoadingView

    @State private var state = StateMachine()
    @State private var taskId = UUID()

    init(
        logger: Logger = Logger(subsystem: "AsyncRecipes", category: "AsyncTaskView"),
        task: @escaping () async throws -> Content,
        @ViewBuilder
        contentView: @escaping (_ content: Content, _ reloadTask: @Sendable @escaping () -> Void) -> ContentView,
        @ViewBuilder
        errorView: @escaping (_ error: any Error, _ previousContent: Content?) -> ErrorView,
        @ViewBuilder
        loadingView: @escaping (_ previousContent: Content?) -> LoadingView
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
        self.init(task: task, contentView: contentView) /* errorView: */ { _, _ in
            Label("Something went wrong!", systemImage: "exclamationmark.triangle.fill")
        } loadingView: { _ in
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
