# UniCoreValidation Examples

Complete, production-ready examples demonstrating how to integrate **UniCoreValidation** in iOS and Android applications.

## Overview

This directory contains three tiers of examples:
1. **Basic Examples**: Single-field validation (email, password)
2. **Intermediate Examples**: Multi-field forms with real-time validation
3. **Advanced Examples**: Complete sign-up forms with complex validation rules

All examples follow best practices for:
- Clean code and architecture
- Real-time validation feedback
- Error display and handling
- Accessible UI/UX
- Platform-specific patterns (SwiftUI for iOS, Compose for Android)

---

## iOS Examples (SwiftUI)

### File Structure
```
Examples/iOS/
├── EmailValidationDemo.swift        # Basic email validation
├── PasswordValidationDemo.swift     # Password with strength indicator
└── SignUpFormDemo.swift             # Complete sign-up form
```

### 1. EmailValidationDemo.swift

**Demonstrates:**
- Real-time email validation
- Visual feedback (checkmark for valid, error for invalid)
- Localization-friendly error messages
- Observable ViewModel pattern

**Key Features:**
```swift
@Observable
final class EmailValidationDemoViewModel {
    var email: String = "" {
        didSet { validateEmail() }
    }
    
    let validator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
}
```

**Usage:**
```swift
// Real-time validation as user types
TextField("enter@email.com", text: $viewModel.email)

// Show error when invalid
if let error = viewModel.validationError {
    Text(error.messageKey)  // "validation.email.invalid"
}
```

### 2. PasswordValidationDemo.swift

**Demonstrates:**
- Password strength calculation (Weak, Fair, Good, Strong)
- Multiple validation rules combined
- Requirements checklist
- Confirm password matching
- Visual strength indicator

**Key Features:**
```swift
private let passwordValidator = Validator(rules: [
    RequiredRule(),
    MinLengthRule(minLength: 8),
    MaxLengthRule(maxLength: 128),
    RegexRule(
        pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
        code: "password.weak",
        messageKey: "validation.password.requiresUpperLowerNumber"
    )
])
```

**Components:**
- `PasswordRequirements`: Visual requirement checklist
- `StatusIndicator`: Real-time validation status
- Color-coded strength meter

### 3. SignUpFormDemo.swift

**Demonstrates:**
- Multi-field form validation
- Progressive error display
- Form completion percentage
- Sectioned form layout
- Submit button enablement based on validation state

**Sections:**
1. **Personal Information**: First Name, Last Name
2. **Account Information**: Email, Username
3. **Security**: Password, Confirm Password

**Key Features:**
```swift
var isFormValid: Bool {
    isFirstNameValid && isLastNameValid && isEmailValid &&
    isUsernameValid && isPasswordValid && isConfirmPasswordValid
}

var completionPercentage: Double {
    let validFields = [...].filter { $0 }.count
    return Double(validFields) / 6.0
}
```

---

## Android Examples (Kotlin & Jetpack Compose)

### File Structure
```
Examples/Android/
├── EmailValidationDemo.kt           # Basic email validation
├── PasswordValidationDemo.kt        # Password with strength indicator
└── SignUpFormDemo.kt                # Complete sign-up form
```

### 1. EmailValidationDemo.kt

**Key Components:**
- `EmailValidationViewModel`: Manages email validation state
- `validateEmailSwift()`: Bridge to Swift SDK (simulated)
- Real-time error display

**Integration with Swift SDK:**
```kotlin
class EmailValidationViewModel : ViewModel() {
    fun validateEmail(input: String) {
        // Calls Swift validation via SDK
        val result = validateEmailSwift(input)
        isValid.value = result.isValid
        validationError.value = result.errors?.firstOrNull()
    }
}
```

### 2. PasswordValidationDemo.kt

**Key Features:**
- `PasswordStrength` enum with color coding
- `PasswordRequirementsChecker` composable
- Real-time strength calculation
- Confirm password validation

**Strength Calculation:**
```kotlin
private fun updatePasswordStrength() {
    var score = 0
    
    if (pwd.length >= 8) score++
    if (pwd.length >= 12) score++
    if (pwd.any { it.isLowerCase() }) score++
    if (pwd.any { it.isUpperCase() }) score++
    if (pwd.any { it.isDigit() }) score++
    if (pwd.any { !it.isLetterOrDigit() }) score++
    
    passwordStrength.value = when (score) {
        in 0..2 -> PasswordStrength.WEAK
        3 -> PasswordStrength.FAIR
        4 -> PasswordStrength.GOOD
        else -> PasswordStrength.STRONG
    }
}
```

### 3. SignUpFormDemo.kt

**Key Components:**
- `SignUpFormViewModel`: Manages all form validation
- `SignUpFormField`: Reusable form field component
- `FormProgressIndicator`: Visual completion progress
- Section-based layout

**Form Field Component:**
```kotlin
@Composable
fun SignUpFormField(
    label: String,
    placeholder: String,
    value: String,
    onValueChange: (String) -> Unit,
    error: ValidationErrorModel?,
    isValid: Boolean
)
```

---

## Validation Rules Demonstrated

### RequiredRule
```swift
// Ensures field is not empty (after trimming)
RequiredRule()
```

**Example Usage:**
```swift
let validator = Validator(rules: [RequiredRule()])
let result = validator.validate("") // Invalid - empty
```

### EmailRule
```swift
// RFC 5322 simplified email validation
EmailRule()
```

**Valid Emails:**
- `user@example.com`
- `john.doe+tag@domain.co.uk`
- `test123@subdomain.example.org`

**Invalid Emails:**
- `plainaddress` (no @)
- `user@` (no domain)
- `user@@example.com` (double @)

### MinLengthRule & MaxLengthRule
```swift
MinLengthRule(minLength: 8)    // At least 8 characters
MaxLengthRule(maxLength: 128)  // At most 128 characters
```

### RegexRule
```swift
RegexRule(
    pattern: "^[a-zA-Z0-9_-]+$",
    code: "username.invalid",
    messageKey: "validation.username.alphanumericOnly"
)
```

### EqualsRule
```swift
EqualsRule(expectedValue: password) // Confirm password matches
```

---

## Error Handling Pattern

All examples follow a consistent error pattern:

```swift
public struct ValidationError {
    public let code: String                // "email.invalid"
    public let messageKey: String          // "validation.email.invalid"  
    public let metadata: [String: String]  // ["minLength": "8"]
}
```

**Advantages:**
1. **Localization-Ready**: `messageKey` allows translation
2. **Code-Driven**: `code` for logging/analytics
3. **UI-Friendly**: `metadata` provides details (min length, etc.)

**Display Pattern:**
```swift
if let error = validationError {
    Text(error.messageKey)  // Translated by app
    
    if let details = error.metadata.first?.value {
        Text("(\(details))")  // Show constraints
    }
}
```

---

## Integration Guide

### iOS Integration

1. **Add Dependency** to your project:
```swift
.package(url: "https://github.com/yourorg/UniCore.git", from: "0.1.0")
```

2. **Import**:
```swift
import UniCoreValidation
```

3. **Create Validator**:
```swift
let validator = Validator(rules: [
    RequiredRule(),
    EmailRule()
])
```

4. **Validate in ViewModel**:
```swift
@Observable
class MyViewModel {
    var email: String = "" {
        didSet {
            let result = validator.validate(email)
            isValid = result.isValid
            error = result.errors?.first
        }
    }
}
```

### Android Integration

1. **Add Swift SDK Dependency** (via gradle):
```gradle
dependencies {
    implementation 'com.example:swift-unicore:0.1.0'
}
```

2. **Create ViewModel** with validation:
```kotlin
class MyViewModel : ViewModel() {
    fun validateEmail(email: String) {
        val result = swiftValidation.validateEmail(email)
        _isValid.value = result.isValid
        _error.value = result.errors?.firstOrNull()
    }
}
```

3. **Use in Compose**:
```kotlin
OutlinedTextField(
    value = email,
    onValueChange = { viewModel.validateEmail(it) }
)

error?.let {
    Text(it.messageKey)
}
```

---

## Best Practices

### 1. Real-Time Validation
- Validate on every keystroke (not just submit)
- Use `@Published` (iOS) or `MutableState` (Android)
- Debounce if making network calls (v1.0+)

### 2. Error Display
- Show errors **only when field has content** (avoid noise)
- Use `messageKey` for localization
- Include `metadata` for constraints (e.g., min length)

### 3. Form Submission
- Disable submit button until all fields valid
- Show progress indicator for multi-step forms
- Consider section validation for large forms

### 4. UX Patterns
- Use visual indicators (checkmark for valid, X for invalid)
- Color-code validation states (green=valid, red=invalid)
- Provide inline requirements (for passwords, usernames)
- Show relevant errors progressively

### 5. Code Organization
- Separate ViewModel from View
- Keep validation logic in ViewModel
- Use Observable/State for reactivity
- Reuse form field components

---

## Testing Examples

### iOS Testing
```swift
func testEmailValidation() {
    let validator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    let validResult = validator.validate("user@example.com")
    XCTAssertTrue(validResult.isValid)
    
    let invalidResult = validator.validate("invalid")
    XCTAssertFalse(invalidResult.isValid)
    XCTAssertEqual(invalidResult.errors?.first?.code, "email.invalid")
}
```

### Android Testing
```kotlin
fun testEmailValidation() {
    val viewModel = EmailValidationViewModel()
    
    viewModel.validateEmail("user@example.com")
    assertTrue(viewModel.isValid.value)
    
    viewModel.validateEmail("invalid")
    assertFalse(viewModel.isValid.value)
    assertEquals("email.invalid", viewModel.validationError.value?.code)
}
```

---

## Extensibility

### Adding Custom Rules

**iOS:**
```swift
struct CustomRule: ValidationRule {
    func validate(_ input: String) -> [ValidationError] {
        // Your validation logic
        if isInvalid(input) {
            return [ValidationError(
                code: "custom.invalid",
                messageKey: "validation.custom.invalid"
            )]
        }
        return []
    }
}
```

**Android:**
```kotlin
fun validateCustom(input: String): ValidationResultModel {
    return if (isInvalid(input)) {
        ValidationResultModel(
            isValid = false,
            errors = listOf(
                ValidationErrorModel(
                    code = "custom.invalid",
                    messageKey = "validation.custom.invalid",
                    metadata = emptyMap()
                )
            )
        )
    } else {
        ValidationResultModel(isValid = true, errors = null)
    }
}
```

---

## Next Steps

### v1.0 Features (Coming Soon)
- Async validation support
- Remote validation (API calls)
- Validation state machines
- Form builder utilities
- More built-in rules

### Future Modules
- **UniCoreForms**: Form state management
- **UniCoreAnalytics**: Validation event tracking
- **UniCoreNetwork**: Remote validation engine

---

## Troubleshooting

### Issue: Validation not updating UI
**Solution**: Ensure ViewModel uses `@Observable` (iOS) or `ViewModel()` (Android)

### Issue: Password strength not showing
**Solution**: Make sure `updatePasswordStrength()` is called in password setter

### Issue: Form submit button not enabling
**Solution**: Verify all required field validators return `isValid = true`

---

## Resources

- [UniCoreValidation Documentation](../VALIDATION.md)
- [Package README](../../README.md)
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)

---

## Questions?

For issues or questions about these examples, see the main project repository.
