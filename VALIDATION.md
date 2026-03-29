# UniCoreValidation

A platform-agnostic, type-safe validation engine for iOS and Android (via Swift SDK) built with clean architecture principles.

## Overview

UniCoreValidation provides:
- ✅ **Pure Domain Logic**: No UI, platform, or framework dependencies
- ✅ **Single Responsibility**: Each rule validates one specific criterion
- ✅ **Strongly Typed Errors**: Machine-readable codes + localization keys
- ✅ **Composable Rules**: Build complex validators by combining simple rules
- ✅ **Thread-Safe**: All types are `Sendable`
- ✅ **Fully Tested**: 50+ comprehensive unit and integration tests

## Architecture

```
UniCoreValidation/
├── Domain/                    # Pure business logic
│   ├── Entities/             # ValidationError, ValidationResult
│   ├── Contracts/            # ValidationRule protocol
│   └── Rules/                # Concrete implementations
├── Application/              # Orchestration layer
│   └── Validators/           # Validator (composes rules)
└── Foundation/               # Technical helpers
    └── Regex/                # RegexValidator
```

### Layer Responsibilities

**Domain**: Core validation logic, zero external dependencies
- ValidationError: Structured error with code, messageKey, and metadata
- ValidationResult: Enum representing valid or invalid state
- ValidationRule: Protocol for all validation rules

**Application**: Orchestrates domain components
- Validator: Composes multiple rules and produces final result

**Foundation**: Technical utilities (no business logic)
- RegexValidator: Regex pattern matching helper

## Available Rules

| Rule | Purpose | Example |
|------|---------|---------|
| `RequiredRule` | Ensures input is not empty (after trimming) | Non-empty field |
| `MinLengthRule` | Enforces minimum character count | Password >= 8 chars |
| `MaxLengthRule` | Enforces maximum character count | Username <= 20 chars |
| `EmailRule` | Validates email format (RFC 5322 simplified) | user@example.com |
| `RegexRule` | Custom regex pattern validation | Phone: `^\d{3}-\d{4}$` |
| `EqualsRule` | Exact value matching | Confirm password matches |

## Usage

### Basic Email Validation

```swift
import UniCoreValidation

let emailValidator = Validator(rules: [
    RequiredRule(),
    EmailRule()
])

let result = emailValidator.validate("user@example.com")
// result.isValid == true

let invalidResult = emailValidator.validate("")
// invalidResult.isValid == false
// invalidResult.errors?.first?.code == "required"
```

### Password Validation

```swift
let passwordValidator = Validator(rules: [
    RequiredRule(),
    MinLengthRule(minLength: 8),
    MaxLengthRule(maxLength: 128)
])

let result = passwordValidator.validate("SecurePass123!")
// result.isValid == true
```

### Username with Custom Regex

```swift
let usernameValidator = Validator(rules: [
    RequiredRule(),
    MinLengthRule(minLength: 3),
    MaxLengthRule(maxLength: 20),
    RegexRule(
        pattern: "^[a-zA-Z0-9_-]+$",
        code: "username.invalid",
        messageKey: "validation.username.invalid"
    )
])

let result = usernameValidator.validate("my_user-123")
// result.isValid == true
```

### Confirmation Field Matching

```swift
let passwordConfirmValidator = Validator(rules: [
    EqualsRule(expectedValue: originalPassword)
])

let result = passwordConfirmValidator.validate(confirmPassword)
```

## Error Handling

All validation errors follow a structured format:

```swift
public struct ValidationError: Equatable, Sendable {
    public let code: String                    // "email.invalid"
    public let messageKey: String              // "validation.email.invalid"
    public let metadata: [String: String]      // ["minLength": "8"]
}
```

Example error for a too-short password:

```swift
ValidationError(
    code: "minLength",
    messageKey: "validation.minLength",
    metadata: ["minLength": "8", "currentLength": "5"]
)
```

The `messageKey` allows you to:
1. **Localize**: Map keys to user-facing messages in any language
2. **Decouple**: UI code stays separate from validation logic
3. **Reuse**: Same validation engine across platforms

## Testing

Run the complete test suite:

```bash
swift test
```

Test coverage includes:
- ✅ Individual rule validation (5-6 tests per rule)
- ✅ Domain model behavior (ValidationError, ValidationResult)
- ✅ Validator orchestration (7 tests)
- ✅ Integration tests (3 realistic scenarios)
- ✅ **Total: 50 comprehensive tests**

## Architecture Principles

### Clean Separation of Concerns

```
Domain (no dependencies)
  ↓
Application (depends on Domain)
  ↓
Foundation (supports both, no business logic)
```

- **Domain** must never import Application or Foundation
- **Application** can depend on Domain
- **Foundation** is never a dependency

### No Hardcoded Strings

All user-facing messages use `messageKey` for localization:

❌ **Don't do this:**
```swift
ValidationError(code: "email", messageKey: "Email is invalid")
```

✅ **Do this:**
```swift
ValidationError(
    code: "email.invalid",
    messageKey: "validation.email.invalid"
)
```

### Single Responsibility

Each rule validates exactly one criterion. Combine rules for complex logic:

❌ Instead of one "PasswordRule" that checks length, format, and complexity...

✅ Use multiple rules:
```swift
[
    RequiredRule(),
    MinLengthRule(minLength: 8),
    RegexRule(pattern: "...", code: "format", messageKey: "...")
]
```

## Design Decisions

### Why Enum for ValidationResult?

```swift
public enum ValidationResult: Equatable, Sendable {
    case valid
    case invalid([ValidationError])
}
```

- **Type Safety**: Cannot accidentally treat invalid as valid
- **Pattern Matching**: Clean handling of both cases
- **No Nullability**: Never returns nil errors

### Why Sendable?

All types conform to `Sendable` for actor support and thread-safe usage in Swift concurrency models.

### Why No Async?

Domain validation is deterministic and local (v0.1.0). Remote/async validation is planned for v1.0.

## Future Expansion

**v1.0+** planned modules:
- `UniCoreForms` - Form state management built on validation
- `UniCoreAnalytics` - Event tracking for validation flows
- `UniCoreNetwork` - Async remote validation
- `UniCoreFlow` - Validation state machines

All will depend on this core foundation layer.

## Contributing

When adding new rules:

1. **Create domain rule** in `Domain/Rules/`
2. **Write tests** in `Tests/UniCoreValidationTests/`
3. **Follow TDD**: Write tests first
4. **Use messageKey**: Never hardcode user messages
5. **Include metadata**: Add context to errors for UI
6. **Document**: Add examples in this README

## License

Part of UniCore cross-platform library.
