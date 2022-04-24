# DebouncedOnChange

A SwiftUI onChange view modifier with additional debounce time.

## Usage

```swift
import SwiftUI
import DebouncedOnChange

struct ExampleView: View {
    @State private var text = ""

    var body: some View {
        TextField("Text", text: $text)
            .onChange(of: text, debounceTime: 2) { newValue in
                // Action executed each time 2 seconds pass since change of text property
            }
    }
}
``` 

## Installation

### Swift Package Manager

Add the following to the dependencies array in your "Package.swift" file:

```swift
.package(url: "https://github.com/Tunous/DebouncedOnChange.git", .upToNextMajor(from: "1.0.0"))
```

Or add https://github.com/Tunous/DebouncedOnChange.git, to the list of Swift packages for any project in Xcode.
