import SwiftUI

extension View {

    /// Adds a modifier for this view that fires an action only when a specified `debounceTime` elapses between value
    /// changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This means that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - initial: Whether the action should be run (after debounce time) when this view initially appears.
    ///   - debounceTime: The time to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS 17, *)
    @available(macOS 14.0, *)
    @available(tvOS 17.0, *)
    @available(watchOS 10.0, *)
    @available(xrOS 1.0, *)
    public func onChange<Value>(
        of value: Value,
        initial: Bool = false,
        debounceTime: Duration,
        _ action: @escaping () -> Void
    ) -> some View where Value: Equatable {
        self.modifier(
            DebouncedChangeNoParamViewModifier(
                trigger: value,
                initial: initial,
                action: action,
                debounceDuration: debounceTime
            )
        )
    }

    /// Adds a modifier for this view that fires an action only when a specified `debounceTime` elapses between value
    /// changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This means that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - initial: Whether the action should be run (after debounce time) when this view initially appears.
    ///   - debounceTime: The time to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS 17, *)
    @available(macOS 14.0, *)
    @available(tvOS 17.0, *)
    @available(watchOS 10.0, *)
    @available(xrOS 1.0, *)
    public func onChange<Value>(
        of value: Value,
        initial: Bool = false,
        debounceTime: Duration,
        _ action: @escaping (_ oldValue: Value, _ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(
            DebouncedChange2ParamViewModifier(
                trigger: value,
                initial: initial,
                action: action,
                debounceDuration: debounceTime
            )
        )
    }

    /// Adds a modifier for this view that fires an action only when a specified `debounceTime` elapses between value
    /// changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This means that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - debounceTime: The time to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    @available(iOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    public func onChange<Value>(
        of value: Value,
        debounceTime: Duration,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChange1ParamViewModifier(trigger: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }

    /// Adds a modifier for this view that fires an action only when a time interval in seconds represented by
    /// `debounceTime` elapses between value changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This means that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime` in seconds.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - debounceTime: The time in seconds to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS, deprecated: 16.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(macOS, deprecated: 13.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(tvOS, deprecated: 16.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(watchOS, deprecated: 9.0, message: "Use version of this method accepting Duration type as debounceTime")
    public func onChange<Value>(
        of value: Value,
        debounceTime: TimeInterval,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChange1ParamViewModifier(trigger: value, action: action) {
            try await Task.sleep(seconds: debounceTime)
        })
    }
}

private struct DebouncedChange1ParamViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: (Value) -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger) { value in
            debouncedTask?.cancel()
            debouncedTask = Task {
                do { try await sleep() } catch { return }
                action(value)
            }
        }
    }
}

@available(iOS 17, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
@available(watchOS 10.0, *)
@available(xrOS 1.0, *)
private struct DebouncedChangeNoParamViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let initial: Bool
    let action: () -> Void
    let debounceDuration: Duration

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger, initial: initial) {
            debouncedTask?.cancel()
            debouncedTask = Task.delayed(duration: debounceDuration, operation: action)
        }
    }
}

@available(iOS 17, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
@available(watchOS 10.0, *)
@available(xrOS 1.0, *)
private struct DebouncedChange2ParamViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let initial: Bool
    let action: (Value, Value) -> Void
    let debounceDuration: Duration

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger, initial: initial) { a, b in
            debouncedTask?.cancel()
            debouncedTask = Task.delayed(duration: debounceDuration) {
                action(a, b)
            }
        }
    }
}
