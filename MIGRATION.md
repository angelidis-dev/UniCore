# Migration Guide

Guide for migrating from hardcoded validation or other validation libraries to **UniCoreValidation v0.1.0**.

## Before UniCoreValidation

### Typical Legacy Code (iOS)
```swift
// ❌ Before: Hardcoded, scattered validation
class SignUpViewController: UIViewController {
    func validateEmail(_ email: String) -> Bool {
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        return NSRegularExpression(pattern: pattern)?.firstMatch(in: email) != nil
    }
    
    func validatePassword(_ password: String) -> String? {
        if password.isEmpty { return "Password required" }
        if password.count < 8 { return "Min 8 characters" }
        if password.count > 128 { return "Max 128 characters" }
        // ... more validations
        return nil
    }
    
    func validateForm() -> Bool {
        let emailValid = validateEmail(email)
        let passwordValid = password.count >= 8
        // ... more duplicate validation logic
        return emailValid && passwordValid
    }
}
```

**Problems:**
- ❌ Validation logic scattered across views/viewmodels
- ❌ Hardcoded error messages (not localizable)
- ❌ Duplicate validation code
- ❌ Difficult to test
- ❌ Inconsistent behavior
- ❌ No code reuse between iOS/Android

### Typical Android Legacy Code
```kotlin
// ❌ Before: Duplicate Android validation
class SignUpActivity : AppCompatActivity() {
    fun validateEmail(email: String): Boolean {
        val pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        return Regex(pattern).matches(email)
    }
    
    fun validatePassword(password: String): String? {
        return when {
            password.isEmpty() -> "Password required"
            password.length < 8 -> "Min 8 characters"
            // ... duplicate logic again
            else -> null
        }
    }
}
```

**Problems:**
- ❌ **Same code written twice** (iOS + Android)
- ❌ Inconsistent rules between platforms
- ❌ Moving to a new project? Start from scratch again

---

## After Migration to UniCoreValidation

### iOS (SwiftUI)
```swift
// ✅ After: Clean, testable, reusable
import UniCoreValidation

@Observable
final class SignUpViewModel {
    var email: String = "" {
        didSet { validateEmail() }
    }
    
    var password: String = "" {
        didSet { validatePassword() }
    }
    
    private let emailValidator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    private let passwordValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 8),
        MaxLengthRule(maxLength: 128)
    ])
    
    var emailError: ValidationError?
    var passwordError: ValidationError?
    var isFormValid: Bool = false
    
    func validateEmail() {
        let result = emailValidator.validate(email)
        emailError = result.errors?.first
    }
    
    func validatePassword() {
        let result = passwordValidator.validate(password)
        passwordError = result.errors?.first
    }
}
```

### Android (Kotlin)
```kotlin
// ✅ After: Same validation via Swift SDK
import com.example.unicore.validation.*

class SignUpViewModel : ViewModel() {
    val email = mutableStateOf("")
    val password = mutableStateOf("")
    
    private val emailValidator = SwiftValidation.createValidator(
        rules = listOf(RequiredRule(), EmailRule())
    )
    
    private val passwordValidator = SwiftValidation.createValidator(
        rules = listOf(
            RequiredRule(),
            MinLengthRule(8),
            MaxLengthRule(128)
        )
    )
    
    fun validateEmail(input: String) {
        email.value = input
        val result = emailValidator.validate(input)
        // Handle result
    }
    
    fun validatePassword(input: String) {
        password.value = input
        val result = passwordValidator.validate(input)
        // Handle result
    }
}
```

**Benefits:**
- ✅ **Single source of truth** (same rules on both platforms)
- ✅ Localizable error messages (messageKey)
- ✅ Easy to test
- ✅ Reusable across projects
- ✅ Type-safe
- ✅ Well-documented

---

## Migration Steps

### Step 1: Add Dependency

#### iOS (Swift Package)
```swift
// Package.swift or Xcode UI
.package(url: "https://github.com/unicore/validation.git", from: "0.1.0")
```

#### Android (Gradle)
```gradle
dependencies {
    // Via Swift SDK bridge (production setup)
    implementation 'com.example:swift-unicore-validation:0.1.0'
}
```

### Step 2: Create Validators

**Identify all validation points** in your app:
- Sign-up form
- Login form
- Profile edit
- Password reset
- etc.

**Create one Validator per validation point:**

```swift
// iOS Example
private let signUpEmailValidator = Validator(rules: [
    RequiredRule(),
    EmailRule()
])

private let signUpPasswordValidator = Validator(rules: [
    RequiredRule(),
    MinLengthRule(minLength: 8),
    MaxLengthRule(maxLength: 128),
    RegexRule(
        pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
        code: "password.weak",
        messageKey: "validation.password.weak"
    )
])
```

### Step 3: Replace Validation Logic

#### Before
```swift
if email.isEmpty {
    showError("Email is required")
    return
}

if !isValidEmail(email) {
    showError("Invalid email format")
    return
}
```

#### After
```swift
let result = signUpEmailValidator.validate(email)

if result.isValid {
    // Proceed
} else if let error = result.errors?.first {
    showError(localizedMessage(for: error.messageKey))
}
```

### Step 4: Update Error Handling

#### Before (Hardcoded)
```swift
func showError(_ message: String) {
    // String in English only
    errorLabel.text = message
}
```

#### After (Localizable)
```swift
func showError(_ messageKey: String) {
    // Localized via Localizable.strings
    errorLabel.text = NSLocalizedString(messageKey, comment: "")
}
```

**Localization file (Localizable.strings):**
```
"validation.required" = "This field is required";
"validation.email.invalid" = "Please enter a valid email address";
"validation.password.weak" = "Password must contain uppercase, lowercase, and numbers";
```

### Step 5: Test Validation

#### Before (Manual testing only)
```swift
// Hope everything works when users try it 🤞
```

#### After (Comprehensive testing)
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

func testPasswordValidation() {
    let validator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 8)
    ])
    
    let weakResult = validator.validate("short")
    XCTAssertFalse(weakResult.isValid)
    XCTAssertEqual(weakResult.errors?.first?.code, "minLength")
}
```

### Step 6: Deploy & Monitor

1. Verify validation behavior matches old system
2. A/B test if needed
3. Monitor error messages in analytics
4. Adjust rules based on user feedback

---

## Common Migration Patterns

### Pattern 1: Simple Email/Password Form

**Before:**
```swift
var isFormValid: Bool {
    !email.isEmpty && 
    isValidEmail(email) &&
    !password.isEmpty &&
    password.count >= 8 &&
    password.count <= 128
}
```

**After:**
```swift
@Observable
class FormViewModel {
    var email: String = "" { didSet { validateEmail() } }
    var password: String = "" { didSet { validatePassword() } }
    
    var isEmailValid = false
    var isPasswordValid = false
    
    private let emailValidator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    private let passwordValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 8),
        MaxLengthRule(maxLength: 128)
    ])
    
    func validateEmail() {
        let result = emailValidator.validate(email)
        isEmailValid = result.isValid
    }
    
    func validatePassword() {
        let result = passwordValidator.validate(password)
        isPasswordValid = result.isValid
    }
    
    var isFormValid: Bool {
        isEmailValid && isPasswordValid
    }
}
```

### Pattern 2: Complex Multi-Field Form

**Before:**
```swift
func validateForm() -> [String: String] {
    var errors = [String: String]()
    
    if firstName.isEmpty {
        errors["firstName"] = "Required"
    }
    if firstName.count < 2 {
        errors["firstName"] = "Minimum 2 characters"
    }
    
    // ... more hardcoded validations
    
    return errors
}
```

**After:**
```swift
@Observable
class ComplexFormViewModel {
    var firstName: String = "" { didSet { validateFirstName() } }
    var lastName: String = "" { didSet { validateLastName() } }
    var email: String = "" { didSet { validateEmail() } }
    var username: String = "" { didSet { validateUsername() } }
    var password: String = "" { didSet { validatePassword() } }
    var confirmPassword: String = "" { didSet { validateConfirmPassword() } }
    
    private let nameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 2),
        MaxLengthRule(maxLength: 50)
    ])
    
    private let emailValidator = Validator(rules: [RequiredRule(), EmailRule()])
    
    private let usernameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 3),
        MaxLengthRule(maxLength: 20),
        RegexRule(
            pattern: "^[a-zA-Z0-9_-]+$",
            code: "username.invalid",
            messageKey: "validation.username.invalid"
        )
    ])
    
    var errors: [String: ValidationError?] = [:]
    
    var isFormValid: Bool {
        !errors.values.contains { $0 != nil }
    }
}
```

### Pattern 3: Custom Validation Rules

**Before:**
```swift
func isValidPhoneNumber(_ phone: String) -> Bool {
    let pattern = "^\\d{3}-\\d{3}-\\d{4}$"
    return NSRegularExpression(pattern: pattern)?.firstMatch(in: phone) != nil
}
```

**After:**
```swift
// Reusable across entire app
let phoneValidator = Validator(rules: [
    RequiredRule(),
    RegexRule(
        pattern: "^\\d{3}-\\d{3}-\\d{4}$",
        code: "phone.invalid",
        messageKey: "validation.phone.invalid"
    )
])

// Use anywhere
let result = phoneValidator.validate(phoneNumber)
```

---

## Rollback Plan (If Needed)

If you need to temporarily rollback:

```swift
// Keep old validation available alongside new
@available(*, deprecated, message: "Use UniCoreValidation instead")
func validateEmailOld(_ email: String) -> Bool {
    // Old implementation
}

// Use new implementation
func validateEmailNew(_ email: String) -> ValidationResult {
    Validator(rules: [RequiredRule(), EmailRule()]).validate(email)
}
```

---

## Performance Impact

### Migration Won't Impact Performance

**Why:**
- ✅ Validation logic is the same (same algorithms)
- ✅ No network calls (unless you choose async validation in v1.0)
- ✅ Minimal memory overhead
- ✅ All operations are synchronous and fast

**Benchmark (v0.1.0):**
```
Email validation: < 0.1ms
Password validation: < 0.1ms
Form validation (6 fields): < 0.5ms
All tests (50): < 20ms total
```

---

## Testing During Migration

### Parallel Testing Strategy

1. **Deploy old validation** (keep working)
2. **Run new validation** behind feature flag
3. **Compare results** (should match)
4. **Gradually roll out** new validation
5. **Remove old code** once stable

```swift
class ValidationManager {
    static let useNewValidation = true  // Feature flag
    
    static func validate(email: String) -> Bool {
        if useNewValidation {
            let result = Validator(rules: [
                RequiredRule(),
                EmailRule()
            ]).validate(email)
            return result.isValid
        } else {
            return validateEmailOld(email)  // Fallback
        }
    }
}
```

---

## FAQ

### Q: Will this break existing code?
**A:** No, UniCoreValidation is additive. Keep old validation code and gradually replace it.

### Q: Can I mix old and new validation?
**A:** Yes, we recommend parallel implementation during migration.

### Q: What about Android?
**A:** Android uses Swift SDK bridge to call the same validation logic. No duplicate code needed.

### Q: How do I migrate error messages?
**A:** Use `messageKey` (localization key) instead of hardcoded strings. Then provide translations in Localizable.strings.

### Q: Will performance be affected?
**A:** No, actually faster since validation is now centralized and testable.

### Q: How long does migration take?
**A:** Depends on app size:
- Simple app: 2-4 hours
- Medium app: 1-2 days
- Large app: 3-5 days

### Q: Can I create custom rules?
**A:** Yes, implement `ValidationRule` protocol and add custom validation logic.

---

## Support

- See [VALIDATION.md](VALIDATION.md) for library documentation
- See [Examples/README.md](Examples/README.md) for code examples
- Check [CHANGELOG.md](CHANGELOG.md) for version history

---

## Next Steps

1. ✅ Add UniCoreValidation dependency
2. ✅ Identify validation points in your app
3. ✅ Create validators for each point
4. ✅ Migrate validation logic one screen at a time
5. ✅ Update error messages to use messageKey
6. ✅ Test thoroughly
7. ✅ Deploy with feature flag
8. ✅ Monitor and adjust
9. ✅ Remove old validation code

**Estimated Total Time**: 1-5 days depending on app complexity

---

**Happy Migrating! 🚀**
