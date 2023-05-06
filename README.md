# DebouncedOnChange

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTunous%2FDebouncedOnChange%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Tunous/DebouncedOnChange) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTunous%2FDebouncedOnChange%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Tunous/DebouncedOnChange)

A SwiftUI onChange and task view modifiers with additional debounce time.

## Usage

```swift
import SwiftUI
import DebouncedOnChange

struct ExampleView: View {
    @State private var text = ""

    var body: some View {
        TextField("Text", text: $text)
            .onChange(of: text, debounceTime: .seconds(2)) { newValue in
                // Action executed each time 2 seconds pass since change of text property
            }
            .task(id: text, debounceTime: .milliseconds(250)) { 
                // Asynchronous action executed each time 250 milliseconds pass since change of text property
            }
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
