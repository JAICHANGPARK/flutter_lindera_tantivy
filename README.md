# Flutter Lindera Tantivy

A high-performance, full-text search application built with Flutter and Rust, featuring Korean language support using Lindera tokenizer and Tantivy search engine.

[한국어](README.ko.md) | [日本語](README.ja.md)

## Features

- **🔍 Full-Text Search**: Powered by Tantivy search engine with BM25 ranking
- **🇰🇷 Korean Language Support**: Advanced Korean text analysis using Lindera tokenizer
- **⚡ High Performance**: Rust-powered backend via Flutter Rust Bridge (FFI)
- **🌍 Multilingual UI**: Support for Korean, English, Japanese, and Chinese
- **🎨 Theme Support**: Light mode, Dark mode, and System theme
- **📱 Cross-Platform**: Supports macOS, Windows, Linux, iOS, and Android
- **💾 Persistent Storage**: Local document indexing with automatic persistence

## Technology Stack

### Frontend
- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **Material 3**: Modern design system

### Backend
- **Rust**: High-performance search engine
- **Tantivy**: Full-text search library
- **Lindera**: Multilingual morphological analyzer
- **flutter_rust_bridge**: FFI bridge between Flutter and Rust

## Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Rust toolchain
- Platform-specific development tools:
  - macOS: Xcode
  - Windows: Visual Studio with C++ support
  - Linux: GCC/Clang
  - iOS: Xcode
  - Android: Android Studio

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_lindera_tantivy.git
cd flutter_lindera_tantivy
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# iOS (requires physical device or simulator)
flutter run -d ios

# Android
flutter run -d android
```

## Usage

### Adding Documents

1. Click the **"Add Document"** button (floating action button)
2. Enter the title and content
3. Optionally add metadata in JSON format
4. Click **"Add"** to index the document

### Searching Documents

1. Enter your search query in the search bar
2. Press Enter or click the **"Search"** button
3. Results are ranked by relevance using BM25 algorithm

### Managing Documents

- **Edit**: Click the edit button on any search result card
- **Delete**: Click the delete button on any search result card
- **Load from JSON**: Use the menu to bulk import documents from JSON file
- **Delete All**: Clear all indexed documents (requires confirmation)

### Theme Customization

Click the theme icon in the app bar to choose:
- 🌞 Light Mode
- 🌙 Dark Mode
- ⚙️ System Mode (follows system settings)

### Language Selection

Click the language icon in the app bar to switch between:
- 🇰🇷 Korean
- 🇺🇸 English
- 🇯🇵 Japanese
- 🇨🇳 Chinese

## Architecture

```
lib/
├── l10n/                 # Localization files
├── models/              # Data models
├── providers/           # Riverpod state providers
├── screens/             # App screens
├── services/            # Business logic
├── widgets/             # Reusable UI components
└── src/rust/            # Generated Rust FFI bindings

rust/
└── src/
    └── api/             # Rust search API
```

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| macOS    | ✅ | Full support |
| Windows  | ✅ | Full support |
| Linux    | ✅ | Full support |
| iOS      | ✅ | Full support |
| Android  | ✅ | Full support |
| Web      | ❌ | Not supported (requires FFI) |

## Dependencies

### Flutter Packages
- `flutter_riverpod`: State management
- `riverpod_annotation`: Code generation for Riverpod
- `flutter_rust_bridge`: Rust FFI integration
- `path_provider`: Local storage access
- `shared_preferences`: Persistent key-value storage

### Rust Crates
- `tantivy`: Full-text search engine
- `lindera`: Morphological analyzer
- `lindera-tantivy`: Tantivy integration for Lindera
- `serde_json`: JSON serialization

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Tantivy](https://github.com/tantivy-search/tantivy) - Fast full-text search engine library
- [Lindera](https://github.com/lindera-morphology/lindera) - Morphological analyzer
- [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge) - High-level FFI bridge

## Contact

Project Link: [https://github.com/yourusername/flutter_lindera_tantivy](https://github.com/yourusername/flutter_lindera_tantivy)
