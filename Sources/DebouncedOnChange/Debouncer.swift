//
//  Debouncer.swift
//  
//
//  Created by Łukasz Rutkowski on 13/07/2024.
//

import Foundation

/// Object which allows manual control of debounced operations.
///
/// You can create an instance of this object and pass it to one of debounced `onChange` functions to be able to
/// manually cancel their execution.
///
/// - Note: A single debouncer should be passed to only one onChange function. If you want to control multiple
///   operations create a separate debouncer for each of them.
///
/// # Example
///
/// Here a debouncer is used to cancel debounced api call and instead trigger it immediately when keyboard return
/// key is pressed.
///
/// ```swift
/// struct Sample: View {
///     @State private var debouncer = Debouncer()
///     @State private var query = ""
///
///     var body: some View {
///         TextField("Query", text: $query)
///             .onKeyPress(.return) {
///                 debouncer.cancel()
///                 callApi()
///                 return .handled
///             }
///             .onChange(of: query, debounceTime: .seconds(1), debouncer: $debouncer) {
///                 callApi()
///             }
///     }
///
///     private func callApi() {
///         print("Sending query \(query)")
///     }
/// }
/// ```
public struct Debouncer {
    var task: Task<Void, Never>?
    
    /// Creates a new debouncer.
    public init() {}

    /// Cancels an operation that is currently being debounced.
    public func cancel() {
        task?.cancel()
    }
}
