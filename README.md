# SF Symbol Finder

A lightweight, performant iOS application for searching and exploring Apple's SF Symbols library.

## About

SF Symbol Finder makes it easy to browse and search through Apple's extensive library of SF Symbols. The app provides semantic search capabilities, allowing you to find symbols based on their meaning rather than just by name.

## Features

- **Semantic Search**: Find symbols based on their meaning using natural language processing
- **Real-time Results**: Get search results as you type with optimized performance
- **Distance Ranking**: Results are ranked by semantic distance (lower is better)
- **Responsive UI**: Smooth scrolling and searching without FPS drops

## Technical Details

The app is built using:
- SwiftUI for the UI
- Combine for reactive programming
- NaturalLanguage framework for semantic search
- Asynchronous processing using Swift's structured concurrency (async/await)

Performance optimizations:
- Debounced search to prevent excessive processing during typing
- Background thread processing for heavy computations
- One-time initialization of language processing models
- Early termination for empty or invalid searches

## Getting Started

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `SFSymbolFinder.xcodeproj` in Xcode
3. Build and run on your device or simulator

## Usage

1. Browse the grid to explore available SF Symbols
2. Type in the search field to find symbols semantically related to your query
3. Results will appear instantly, sorted by semantic distance

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgements

- [Apple SF Symbols](https://developer.apple.com/sf-symbols/) for providing the symbol library
- Apple's NaturalLanguage framework for semantic search capabilities 