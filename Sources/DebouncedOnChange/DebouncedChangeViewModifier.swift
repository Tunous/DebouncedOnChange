import SwiftUI

extension View {

    /// Adds a modifier for this view that fires an action only when a specified `debounceTime` elapses between value
    /// changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - duration: The time to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS 16.0, *)
    @available(macOS 14.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    public func onChange<Value>(
        of value: Value,
        debounceTime: Duration,
        perform action: @escaping (_ oldValue: Value, _ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChangeViewModifier(trigger: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }
}

@available(iOS 16.0, *)
@available(macOS 14.0, *)
@available(tvOS 16.0, *)
@available(watchOS 9.0, *)
private struct DebouncedChangeViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: (Value, Value) -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger) { oldValue, value in
            debouncedTask?.cancel()
            debouncedTask = Task {
                do { try await sleep() } catch { return }
                action(oldValue, value)
            }
        }
    }
}
