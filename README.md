# DebouncedOnChange

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTunous%2FDebouncedOnChange%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Tunous/DebouncedOnChange) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTunous%2FDebouncedOnChange%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Tunous/DebouncedOnChange)

A SwiftUI onChange and task view modifiers with additional debounce time.

[Documentation](https://swiftpackageindex.com/Tunous/DebouncedOnChange/main/documentation/debouncedonchange)

## Usage

### Basics

```swift
import SwiftUI
import DebouncedOnChange

struct ExampleView: View {
    @State private var text = ""

    var body: some View {
        TextField("Text", text: $text)
            .onChange(of: text, debounceTime: .seconds(2)) { oldValue, newValue in
                // Action executed each time 2 seconds pass since change of text property
            }
            .task(id: text, debounceTime: .milliseconds(250)) { 
                // Asynchronous action executed each time 250 milliseconds pass since change of text property
            }
    }
}
```

### Manually cancelling debounced actions

```swift
struct Sample: View {
    @State private var debouncer = Debouncer() // 1. Store debouncer to control actions
    @State private var query = ""
    
    var body: some View {
        TextField("Query", text: $query)
            .onChange(of: query, debounceTime: .seconds(1), debouncer: $debouncer) { // 2. Pass debouncer to onChange
                callApi()
            }
            .onKeyPress(.return) {
                debouncer.cancel() // 3. Call cancel to prevent debounced action from running
                callApi()
                return .handled
            }
    }
    
    private func callApi() {
        print("Sending query \(query)")
    }
}
```

## Installation

### Swift Package Manager

Add the following to the dependencies array in your "Package.swift" file:

```swift
.package(url: "https://github.com/Tunous/DebouncedOnChange.git", .upToNextMajor(from: "1.1.0"))
```

Or add https://github.com/Tunous/DebouncedOnChange.git, to the list of Swift packages for any project in Xcode.
