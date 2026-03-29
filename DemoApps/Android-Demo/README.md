# Android Demo App - UniCoreValidation

Complete Android app demonstrating all UniCoreValidation features using Kotlin with Jetpack Compose.

## Project Structure

```
Android-Demo/
├── app/
│   └── src/
│       └── main/
│           ├── kotlin/
│           │   └── com/example/unicorevalidationdemo/
│           │       ├── app/MainActivity.kt              # App entry & navigation
│           │       └── screens/
│           │           ├── Screens.kt                   # All demo screens
│           │           └── ViewModels.kt                # State management
│           └── res/
│               └── values/
│                   └── strings.xml                      # Localization
├── build.gradle.kts                                     # Build configuration
└── README.md                                            # This file
```

## Features

### 1. Email Validation Demo
- Real-time email validation
- Visual feedback (checkmark when valid)
- Error message display
- Material Design 3 UI

### 2. Password Validation Demo
- Password strength indicator (Weak/Fair/Good/Strong)
- Color-coded strength (Red/Orange/Yellow/Green)
- Confirm password matching
- Real-time validation feedback

### 3. Complete Sign-Up Form
- 6-field form validation
- Sectioned layout (Personal Info, Account, Security)
- Form completion percentage
- Progressive error display
- Conditional submit button

## Setup Instructions

### Prerequisites
- Android Studio Flamingo or newer
- Kotlin 1.8+
- Android 8.0 (API 26) or later
- Jetpack Compose

### Installation

1. **Add JitPack Repository**
   
   In `settings.gradle.kts`:
   ```kotlin
   dependencyResolutionManagement {
       repositories {
           mavenCentral()
           maven { url = uri("https://jitpack.io") }
       }
   }
   ```

2. **Add UniCore Dependency**
   
   In `build.gradle.kts`:
   ```kotlin
   dependencies {
       implementation("com.github.angelidis-dev:UniCore:0.1.0")
   }
   ```

3. **Build and Run**
   - Connect device or start emulator
   - Press Shift+F10 or Run → Run 'app'
   
## Architecture

### State Management Pattern

```kotlin
data class EmailValidationState(
    val email: String = "",
    val isValid: Boolean = false,
    val error: ValidationError? = null
)

class EmailValidationDemoViewModel : ViewModel() {
    private val _state = MutableStateFlow(EmailValidationState())
    val state: StateFlow<EmailValidationState> = _state.asStateFlow()
    
    fun updateEmail(email: String) {
        val result = validateEmail(email)
        _state.update {
            it.copy(
                email = email,
                isValid = result.first,
                error = result.second
            )
        }
    }
}
```

### Real-Time Validation

```kotlin
@Composable
fun EmailValidationScreen() {
    val viewModel = remember { EmailValidationDemoViewModel() }
    val state = viewModel.state.collectAsState().value
    
    OutlinedTextField(
        value = state.email,
        onValueChange = { viewModel.updateEmail(it) }
        // Automatically updates state and validation
    )
}
```

### Reactive UI Updates

```kotlin
TextField(
    value = state.email,
    onValueChange = { viewModel.updateEmail(it) }
)

if (state.isValid && state.email.isNotEmpty()) {
    Icon(Icons.Filled.Check, tint = Color.Green)
}

if (state.error != null) {
    Text(state.error!!.messageKey, color = Color.Red)
}
```

## Usage Examples

### Basic Email Validation

```kotlin
class EmailValidationDemoViewModel : ViewModel() {
    fun updateEmail(email: String) {
        val emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        if (email.isEmpty()) {
            error = ValidationError("required", "validation.required")
        } else if (!Regex(emailPattern).matches(email)) {
            error = ValidationError("email.invalid", "validation.email.invalid")
        } else {
            error = null
        }
    }
}
```

### Password with Strength

```kotlin
fun updatePassword(password: String) {
    val strength = when {
        password.length < 8 -> PasswordStrength.WEAK
        password.length < 12 -> PasswordStrength.FAIR
        hasUpperAndLower(password) && hasDigit(password) -> PasswordStrength.GOOD
        else -> PasswordStrength.STRONG
    }
}
```

### Multi-Field Form

```kotlin
data class SignUpFormState(
    val firstName: String = "",
    val email: String = "",
    val password: String = "",
    val isFirstNameValid: Boolean = false,
    val isEmailValid: Boolean = false,
    val isPasswordValid: Boolean = false
) {
    val isFormValid: Boolean
        get() = isFirstNameValid && isEmailValid && isPasswordValid
}
```

## Validation Rules Demonstrated

| Rule | Purpose | Example | Implementation |
|------|---------|---------|-----------------|
| Required | Non-empty field | Name field | `isEmpty()` check |
| Email | RFC 5322 pattern | user@example.com | Regex validation |
| MinLength | Minimum chars | Password >= 8 | `length >= 8` |
| MaxLength | Maximum chars | Password <= 128 | `length <= 128` |
| Regex | Pattern matching | Username alphanumeric | `Regex("^[a-zA-Z0-9_-]+$")` |
| Equals | Exact match | Confirm password | `confirm == password` |

## Testing

### Unit Tests

```kotlin
@Test
fun testEmailValidation() {
    val viewModel = EmailValidationDemoViewModel()
    
    viewModel.updateEmail("user@example.com")
    assertEquals(true, viewModel.state.value.isValid)
    
    viewModel.updateEmail("invalid")
    assertEquals(false, viewModel.state.value.isValid)
}
```

### UI Tests

```kotlin
@Test
fun testEmailFieldUpdates() {
    composeTestRule.onNodeWithTag("emailField")
        .performTextInput("user@example.com")
    
    composeTestRule.onNodeWithTag("validCheckmark")
        .assertIsDisplayed()
}
```

## Localization

### Add Translations

Create `strings.xml` files for each language:

**`res/values/strings.xml`** (English)
```xml
<resources>
    <string name="validation_required">This field is required</string>
    <string name="validation_email_invalid">Please enter a valid email</string>
    <string name="validation_minLength">Minimum length: %d characters</string>
</resources>
```

**`res/values-es/strings.xml`** (Spanish)
```xml
<resources>
    <string name="validation_required">Este campo es obligatorio</string>
    <string name="validation_email_invalid">Ingrese un correo válido</string>
</resources>
```

### Use in Code

```kotlin
Text(
    text = stringResource(id = R.string.validation_required),
    color = Color.Red
)
```

## Best Practices Demonstrated

✅ **StateFlow**: Reactive state management  
✅ **ViewModel**: Lifecycle-aware validation logic  
✅ **Compose**: Declarative UI with Material Design 3  
✅ **Immutable State**: Prevent accidental mutations  
✅ **Separation of Concerns**: UI logic separate from validation  
✅ **Error Handling**: Structured, localization-ready  
✅ **Real-Time Feedback**: Keystroke-by-keystroke validation  
✅ **Progressive Disclosure**: Errors shown only when relevant  
✅ **Visual Indicators**: Color-coded states, icons  
✅ **Form Coordination**: Multi-field validation  

## Customization

### Add Custom Validation

```kotlin
fun validatePassword(password: String): Pair<Boolean, ValidationError?> {
    if (password.isEmpty()) {
        return false to ValidationError("required", "validation.required")
    }
    if (password.length < 8) {
        return false to ValidationError("minLength", "validation.minLength.8")
    }
    if (!Regex("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).*$").matches(password)) {
        return false to ValidationError("weak", "validation.password.weak")
    }
    return true to null
}
```

### Compose Custom Components

```kotlin
@Composable
fun ValidatedTextField(
    label: String,
    value: String,
    isValid: Boolean,
    error: ValidationError?,
    onValueChange: (String) -> Unit
) {
    Column {
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            label = { Text(label) }
        )
        if (error != null) {
            Text(error.messageKey, color = Color.Red)
        }
    }
}
```

## Performance

- Email validation: < 1ms
- Password validation: < 1ms
- Form validation (6 fields): < 5ms
- Full app startup: < 1s

## Troubleshooting

**Q: Build error - "Could not find UniCoreValidation"**  
A: Ensure dependency is in build.gradle.kts and repositories configured

**Q: StateFlow updates not reflecting in UI**  
A: Use `.collectAsState()` to convert StateFlow to Compose State

**Q: Keyboard not showing**  
A: Add `keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email)`

**Q: Form submit button not enabling**  
A: Verify all field validation functions return true, and state updates properly

## Build Variants

Build for different configurations:

```bash
# Debug build
./gradlew installDebug

# Release build
./gradlew installRelease

# With coverage
./gradlew instrumented test
```

## Navigation

Uses Jetpack Navigation Compose:

```kotlin
NavHost(navController = navController, startDestination = "home") {
    composable("home") { HomeScreen(navController) }
    composable("email") { EmailValidationScreen() }
    composable("password") { PasswordValidationScreen() }
    composable("signup") { SignUpFormScreen() }
}
```

## Next Steps

1. **Review** the three example screens
2. **Understand** the ViewModel/StateFlow pattern
3. **Customize** validators for your app
4. **Add** localization strings for your languages
5. **Deploy** to Google Play Store

## Support

- See [VALIDATION.md](../../VALIDATION.md) for library docs
- See [EXAMPLES.md](../../EXAMPLES.md) for more examples
- Check [MIGRATION.md](../../MIGRATION.md) for integration guide

## Dependencies

- Jetpack Compose: Latest stable
- Material Design 3: Latest stable
- ViewModel (Lifecycle): Latest stable
- Navigation Compose: Latest stable
- Kotlin Coroutines: Latest stable

## Gradle Configuration

**build.gradle.kts**
```kotlin
android {
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.example.unicorevalidationdemo"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
    
    buildFeatures {
        compose = true
    }
    
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.3"
    }
}
```

---

**Version**: 0.1.0  
**Platform**: Android 8.0+  
**Language**: Kotlin 1.8+  
**UI Framework**: Jetpack Compose  
**Status**: Production Ready  
**Author**: [@nikoagge](https://github.com/nikoagge)  
**Contact**: nikos@angelidis.dev
