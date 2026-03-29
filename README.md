# UniCore

A cross-platform validation library for Swift (iOS, macOS) and Kotlin (Android) applications.

[![Swift 6.0+](https://img.shields.io/badge/Swift-6.0+-orange.svg?style=flat)](https://swift.org)
[![iOS 13.0+](https://img.shields.io/badge/iOS-13.0+-blue.svg?style=flat)](https://www.apple.com/ios)
[![Android 8.0+](https://img.shields.io/badge/Android-8.0+-green.svg?style=flat)](https://www.android.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-50%2F50%20PASSING-brightgreen.svg)](#testing)

## Overview

UniCore is a production-ready validation library designed for modern cross-platform development. It provides:

- **Type-Safe Validation**: Enum-based result types prevent runtime errors
- **Composable Rules**: Build complex validations by combining simple, reusable rules
- **Zero Dependencies**: Pure Swift/Kotlin, no external libraries required
- **Localization Ready**: Built-in support for translated error messages
- **Real-Time Feedback**: Perfect for reactive UI frameworks (SwiftUI, Compose)
- **Thread-Safe**: Sendable types for concurrent iOS/macOS development

## Quick Start

### Installation

#### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/angelidis-dev/UniCore.git", 
             from: "0.1.0")
]
```

#### Android (Gradle)
```gradle
// In settings.gradle.kts
dependencyResolutionManagement {
    repositories {
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

// In build.gradle.kts
dependencies {
    implementation("com.github.angelidis-dev:UniCore:0.1.0")
}
```

### Basic Usage

#### iOS (SwiftUI)
```swift
import SwiftUI
import UniCoreValidation

struct LoginView: View {
    @State private var email = ""
    @State private var isEmailValid = false
    
    let validator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    var body: some View {
        TextField("Email", text: $email)
            .onChange(of: email) { newValue in
                let result = validator.validate(newValue)
                isEmailValid = result.isValid
            }
    }
}
```

#### Android (Kotlin)
```kotlin
import com.example.unicore.validation.*

class LoginViewModel : ViewModel() {
    private val emailValidator = Validator(rules = listOf(
        RequiredRule(),
        EmailRule()
    ))
    
    fun validateEmail(email: String) {
        val result = emailValidator.validate(email)
        if (result.isValid) {
            // Proceed
        } else {
            result.errors?.forEach { error ->
                Log.d("Validation", error.messageKey)
            }
        }
    }
}
```

## Features

### Validation Rules

Built-in rules for common validation scenarios:

| Rule | Purpose | Example |
|------|---------|---------|
| `RequiredRule` | Non-empty field | Name field |
| `EmailRule` | RFC 5322 email | user@example.com |
| `MinLengthRule` | Minimum length | Password >= 8 chars |
| `MaxLengthRule` | Maximum length | Field <= 255 chars |
| `RegexRule` | Pattern matching | Username alphanumeric |
| `EqualsRule` | Exact match | Confirm password |

### Extensibility

Create custom rules by implementing the `ValidationRule` protocol:

```swift
struct PhoneNumberRule: ValidationRule {
    func validate(_ input: String) -> [ValidationError] {
        guard Regex("^\\d{3}-\\d{3}-\\d{4}$").matches(input) else {
            return [ValidationError(
                code: "phone.invalid",
                messageKey: "validation.phone.invalid"
            )]
        }
        return []
    }
}
```

### Real-Time Validation

Designed for modern reactive frameworks:

```swift
// iOS + SwiftUI
@Observable final class FormViewModel {
    var email: String = "" {
        didSet { validateEmail() }
    }
    
    private func validateEmail() {
        let result = validator.validate(email)
        isEmailValid = result.isValid
        emailError = result.errors?.first
    }
}

// Android + Compose
@Composable
fun EmailField() {
    val viewModel = remember { EmailViewModel() }
    val state by viewModel.state.collectAsState()
    
    TextField(
        value = state.email,
        onValueChange = { viewModel.updateEmail(it) }
    )
}
```

## Documentation

- **[VALIDATION.md](VALIDATION.md)** — Complete API reference and architecture guide
- **[EXAMPLES.md](EXAMPLES.md)** — Comprehensive usage examples for iOS and Android
- **[MIGRATION.md](MIGRATION.md)** — Integration guide for existing projects
- **[CHANGELOG.md](CHANGELOG.md)** — Version history and release notes

## Demo Apps

See the library in action:

- **[iOS Demo](DemoApps/iOS-Demo)** — SwiftUI example app with real-time validation
- **[Android Demo](DemoApps/Android-Demo)** — Kotlin Compose example app
- **[Examples Folder](Examples)** — Standalone code examples

## Testing

All 50 core tests passing:

```bash
swift test
```

Test coverage includes:
- ✅ Domain layer validation
- ✅ All 6 validation rules
- ✅ Error handling and collection
- ✅ Form orchestration
- ✅ Edge cases and boundary conditions

## Architecture

```
UniCore
├── Domain Layer (Pure Business Logic)
│   ├── ValidationError
│   ├── ValidationResult
│   └── ValidationRule (Protocol)
├── Validation Rules (6 Rules)
│   ├── RequiredRule
│   ├── EmailRule
│   ├── MinLengthRule
│   ├── MaxLengthRule
│   ├── RegexRule
│   └── EqualsRule
├── Application Layer
│   └── Validator (Orchestration)
└── Foundation Layer
    └── RegexValidator (Technical Implementation)
```

**Design Principles:**
- No external dependencies
- Immutable data structures
- Type-safe error handling
- Thread-safe (Sendable conformance)
- Localization-friendly

## Platform Support

| Platform | Minimum Version | Status |
|----------|-----------------|--------|
| iOS | 13.0+ | ✅ Supported |
| macOS | 10.15+ | ✅ Supported |
| Android | 8.0 (API 26) | ✅ Supported |
| tvOS | 13.0+ | ✅ Supported |
| watchOS | 6.0+ | ✅ Supported |

## CI/CD

Automated testing and quality checks powered by GitHub Actions:

- **Tests**: Runs on Swift 5.9, 6.0 across macOS 13, 14
- **Quality**: Code analysis, dependency checks, security scanning
- **Publishing**: Automated releases and documentation

## License

MIT License - see [LICENSE](LICENSE) for details

---

**Questions?**
- Check [EXAMPLES.md](EXAMPLES.md) for usage examples
- Review [VALIDATION.md](VALIDATION.md) for technical details
- See [MIGRATION.md](MIGRATION.md) for integration steps
- Open an issue for bug reports

---

## Author

Nikos Angelidis ([@nikoagge](https://github.com/nikoagge))

For collaboration requests, feature proposals, or improvements send to [nikos@angelidis.dev](mailto:nikos@angelidis.dev)

---

**Version**: 0.1.0  
**Status**: Production Ready  
**License**: MIT
