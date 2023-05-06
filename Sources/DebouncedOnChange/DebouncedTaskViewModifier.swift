import SwiftUI

extension View {

    /// Adds a task to perform before this view appears or when a specified value changes and a specified
    /// `debounceTime` elapses between value changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes. The value must conform to the `Equatable` protocol.
    ///   - duration: The time to wait after each value change before running `action` closure.
    ///   - action: A closure called after debounce time as an asynchronous task before the view appears. SwiftUI can automatically cancel the task after the view disappears before the action completes. If the id value changes, SwiftUI cancels and restarts the task.
    /// - Returns: A view that runs the specified action asynchronously before the view appears, or restarts the task with the id value changes after debounced time.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    public func task<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        debounceTime: Duration,
        _ action: @escaping () async -> Void
    ) -> some View where T : Equatable {
        self.task(id: value, priority: priority) {
            do { try await Task.sleep(for: debounceTime) } catch { return }
            await action()
        }
    }
}
