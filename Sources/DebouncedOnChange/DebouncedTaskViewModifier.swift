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
    ///   - action: A closure called after debounce time as an asynchronous task before the view appears. SwiftUI can
    ///     automatically cancel the task after the view disappears before the action completes. If the id value
    ///     changes, SwiftUI cancels and restarts the task.
    /// - Returns: A view that runs the specified action asynchronously before the view appears, or restarts the task
    ///     with the id value changes after debounced time.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    public func task<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        debounceTime: Duration,
        _ action: @escaping () async -> Void
    ) -> some View where T: Equatable {
        self.task(id: value, priority: priority) {
            do { try await Task.sleep(for: debounceTime) } catch { return }
            await action()
        }
    }

    /// Adds a task to perform when this view appears or when a specified value changes and a specified
    /// `debounceTime` elapses between value changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes. The value must conform to the `Equatable` protocol.
    ///   - duration: The time to wait after each value change before running `action` closure.
    ///   - debouncer: Object used to manually cancel debounced actions.   
    ///   - action: A closure called after debounce time as an asynchronous task before the view appears. SwiftUI can
    ///     automatically cancel the task after the view disappears before the action completes. If the id value
    ///     changes, SwiftUI cancels and restarts the task.
    /// - Returns: A view that runs the specified action asynchronously before the view appears, or restarts the task
    ///     with the id value changes after debounced time.
    @available(iOS 17, *)
    @available(macOS 14.0, *)
    @available(tvOS 17.0, *)
    @available(watchOS 10.0, *)
    @available(visionOS 1.0, *)
    public func task<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        debounceTime: Duration,
        debouncer: Binding<Debouncer>,
        _ action: @escaping () async -> Void
    ) -> some View where T: Equatable {
        self.modifier(
            DebouncedTaskViewModifier(
                trigger: value,
                action: action,
                debounceDuration: debounceTime,
                debouncer: debouncer
            )
        )
    }
}

@available(iOS 17, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
@available(watchOS 10.0, *)
@available(visionOS 1.0, *)
private struct DebouncedTaskViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: () async -> Void
    let debounceDuration: Duration
    let debouncer: Binding<Debouncer>

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger, initial: true) {
            debouncedTask?.cancel()
            debouncedTask = Task.delayed(duration: debounceDuration) {
                await action()
            }
            debouncer.wrappedValue.task = debouncedTask
        }
    }
}
