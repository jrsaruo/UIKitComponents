# UIKitComponents

Reusable UI components built with UIKit.

## Requirements

- iOS 13.0+ / tvOS 13.0+
- Swift 5.6+

## Components

### `TextViewWithPlaceholder`

`UITextView` with a placeholder.

```swift
let textView = TextViewWithPlaceholder()
textView.placeholder = "email@example.com"

// The appearance of the placeholder follows that of text view.
textView.font = .preferredFont(forTextStyle: .body)
textView.textAlignment = .center
textView.textContainerInset = .zero
textView.textContainer.lineFragmentPadding = 0
// etc...
```

## Using UIKitComponents in your project

To use the `UIKitComponents` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/jrsaruo/UIKitComponents", from: "1.0.1"),
```

and add `UIKitComponents` as a dependency for your target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "UIKitComponents", package: "UIKitComponents"),
    // other dependencies
]),
```

Finally, add `import UIKitComponents` in your source code.
