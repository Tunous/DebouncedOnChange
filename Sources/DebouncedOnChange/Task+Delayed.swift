import Foundation

extension Task {

    /// Asynchronously runs the given `operation` in its own task after the specified number of `seconds`.
    ///
    /// The operation will be executed after specified number of `seconds` passes. You can cancel the task earlier
    /// for the operation to be skipped.
    ///
    /// - Parameters:
    ///   - time: Delay time in seconds.
    ///   - operation: The operation to execute.
    /// - Returns: Handle to the task which can be cancelled.
    @discardableResult
    public static func delayed(
        seconds: TimeInterval,
        operation: @escaping @Sendable () async -> Void
    ) -> Self where Success == Void, Failure == Never {
        Self {
            do {
                try await Task<Never, Never>.sleep(seconds: seconds)
                await operation()
            } catch {}
        }
    }

    static func sleep(seconds: TimeInterval) async throws where Success == Never, Failure == Never {
        try await Task<Success, Failure>.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
