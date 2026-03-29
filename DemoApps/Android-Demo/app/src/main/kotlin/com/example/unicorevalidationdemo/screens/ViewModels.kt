package com.example.unicorevalidationdemo.screens

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

// MARK: - Email Validation ViewModel

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
    
    private fun validateEmail(email: String): Pair<Boolean, ValidationError?> {
        if (email.isEmpty()) {
            return false to ValidationError(
                code = "required",
                messageKey = "validation.required"
            )
        }
        
        val emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        if (!Regex(emailPattern).matches(email)) {
            return false to ValidationError(
                code = "email.invalid",
                messageKey = "validation.email.invalid"
            )
        }
        
        return true to null
    }
}

// MARK: - Password Validation ViewModel

data class PasswordValidationState(
    val password: String = "",
    val confirmPassword: String = "",
    val isPasswordValid: Boolean = false,
    val isConfirmValid: Boolean = false,
    val passwordStrength: PasswordStrength = PasswordStrength.WEAK,
    val allValid: Boolean = false
)

class PasswordValidationDemoViewModel : ViewModel() {
    private val _state = MutableStateFlow(PasswordValidationState())
    val state: StateFlow<PasswordValidationState> = _state.asStateFlow()
    
    fun updatePassword(password: String) {
        val isValid = validatePassword(password)
        val strength = calculatePasswordStrength(password)
        
        _state.update {
            val confirmValid = validateConfirm(it.confirmPassword, password)
            it.copy(
                password = password,
                isPasswordValid = isValid,
                passwordStrength = strength,
                isConfirmValid = confirmValid && it.confirmPassword.isNotEmpty(),
                allValid = isValid && confirmValid && strength == PasswordStrength.STRONG
            )
        }
    }
    
    fun updateConfirmPassword(confirm: String) {
        val confirmValid = validateConfirm(confirm, state.value.password)
        
        _state.update {
            it.copy(
                confirmPassword = confirm,
                isConfirmValid = confirmValid && it.password.isNotEmpty(),
                allValid = it.isPasswordValid && confirmValid && it.passwordStrength == PasswordStrength.STRONG
            )
        }
    }
    
    private fun validatePassword(password: String): Boolean {
        if (password.length < 8) return false
        if (password.length > 128) return false
        
        val hasLower = password.any { it.isLowerCase() }
        val hasUpper = password.any { it.isUpperCase() }
        val hasDigit = password.any { it.isDigit() }
        
        return hasLower && hasUpper && hasDigit
    }
    
    private fun validateConfirm(confirm: String, password: String): Boolean {
        return confirm == password && confirm.isNotEmpty()
    }
    
    private fun calculatePasswordStrength(password: String): PasswordStrength {
        if (password.isEmpty()) return PasswordStrength.WEAK
        
        var score = 0
        
        if (password.length >= 8) score += 1
        if (password.length >= 12) score += 1
        
        if (password.any { it.isLowerCase() }) score += 1
        if (password.any { it.isUpperCase() }) score += 1
        if (password.any { it.isDigit() }) score += 1
        if (password.any { !it.isLetterOrDigit() }) score += 1
        
        return when (score) {
            in 0..2 -> PasswordStrength.WEAK
            3 -> PasswordStrength.FAIR
            4 -> PasswordStrength.GOOD
            else -> PasswordStrength.STRONG
        }
    }
}

// MARK: - Sign-Up Form ViewModel

data class SignUpFormState(
    val firstName: String = "",
    val lastName: String = "",
    val email: String = "",
    val username: String = "",
    val password: String = "",
    val confirmPassword: String = "",
    val isFirstNameValid: Boolean = false,
    val isLastNameValid: Boolean = false,
    val isEmailValid: Boolean = false,
    val isUsernameValid: Boolean = false,
    val isPasswordValid: Boolean = false,
    val isConfirmPasswordValid: Boolean = false,
    val firstNameError: ValidationError? = null,
    val lastNameError: ValidationError? = null,
    val emailError: ValidationError? = null,
    val usernameError: ValidationError? = null,
    val passwordError: ValidationError? = null,
    val confirmPasswordError: ValidationError? = null,
    val isFormValid: Boolean = false,
    val completionPercentage: Double = 0.0
)

class SignUpFormDemoViewModel : ViewModel() {
    private val _state = MutableStateFlow(SignUpFormState())
    val state: StateFlow<SignUpFormState> = _state.asStateFlow()
    
    fun updateFirstName(name: String) {
        val (isValid, error) = validateName(name)
        updateFormState { state ->
            state.copy(
                firstName = name,
                isFirstNameValid = isValid,
                firstNameError = error
            )
        }
    }
    
    fun updateLastName(name: String) {
        val (isValid, error) = validateName(name)
        updateFormState { state ->
            state.copy(
                lastName = name,
                isLastNameValid = isValid,
                lastNameError = error
            )
        }
    }
    
    fun updateEmail(email: String) {
        val (isValid, error) = validateEmail(email)
        updateFormState { state ->
            state.copy(
                email = email,
                isEmailValid = isValid,
                emailError = error
            )
        }
    }
    
    fun updateUsername(username: String) {
        val (isValid, error) = validateUsername(username)
        updateFormState { state ->
            state.copy(
                username = username,
                isUsernameValid = isValid,
                usernameError = error
            )
        }
    }
    
    fun updatePassword(password: String) {
        val (isValid, error) = validatePassword(password)
        updateFormState { state ->
            val confirmValid = password == state.confirmPassword && state.confirmPassword.isNotEmpty()
            state.copy(
                password = password,
                isPasswordValid = isValid,
                passwordError = error,
                isConfirmPasswordValid = confirmValid
            )
        }
    }
    
    fun updateConfirmPassword(confirm: String) {
        val valid = confirm == state.value.password && confirm.isNotEmpty()
        updateFormState { state ->
            state.copy(
                confirmPassword = confirm,
                isConfirmPasswordValid = valid
            )
        }
    }
    
    private fun updateFormState(updateBlock: (SignUpFormState) -> SignUpFormState) {
        _state.update { currentState ->
            val newState = updateBlock(currentState)
            newState.copy(
                isFormValid = newState.isFirstNameValid &&
                              newState.isLastNameValid &&
                              newState.isEmailValid &&
                              newState.isUsernameValid &&
                              newState.isPasswordValid &&
                              newState.isConfirmPasswordValid,
                completionPercentage = calculateCompletion(newState)
            )
        }
    }
    
    private fun validateName(name: String): Pair<Boolean, ValidationError?> {
        if (name.isEmpty()) {
            return false to ValidationError("required", "validation.required")
        }
        if (name.length < 2) {
            return false to ValidationError("minLength", "validation.minLength.2")
        }
        if (name.length > 50) {
            return false to ValidationError("maxLength", "validation.maxLength.50")
        }
        return true to null
    }
    
    private fun validateEmail(email: String): Pair<Boolean, ValidationError?> {
        if (email.isEmpty()) {
            return false to ValidationError("required", "validation.required")
        }
        val emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        if (!Regex(emailPattern).matches(email)) {
            return false to ValidationError("email.invalid", "validation.email.invalid")
        }
        return true to null
    }
    
    private fun validateUsername(username: String): Pair<Boolean, ValidationError?> {
        if (username.isEmpty()) {
            return false to ValidationError("required", "validation.required")
        }
        if (username.length < 3) {
            return false to ValidationError("minLength", "validation.minLength.3")
        }
        if (username.length > 20) {
            return false to ValidationError("maxLength", "validation.maxLength.20")
        }
        val pattern = "^[a-zA-Z0-9_-]+$"
        if (!Regex(pattern).matches(username)) {
            return false to ValidationError("invalid", "validation.username.invalid")
        }
        return true to null
    }
    
    private fun validatePassword(password: String): Pair<Boolean, ValidationError?> {
        if (password.isEmpty()) {
            return false to ValidationError("required", "validation.required")
        }
        if (password.length < 8) {
            return false to ValidationError("minLength", "validation.minLength.8")
        }
        if (password.length > 128) {
            return false to ValidationError("maxLength", "validation.maxLength.128")
        }
        
        val hasLower = password.any { it.isLowerCase() }
        val hasUpper = password.any { it.isUpperCase() }
        val hasDigit = password.any { it.isDigit() }
        
        if (!hasLower || !hasUpper || !hasDigit) {
            return false to ValidationError("weak", "validation.password.weak")
        }
        
        return true to null
    }
    
    private fun calculateCompletion(state: SignUpFormState): Double {
        val validFields = listOf(
            state.isFirstNameValid,
            state.isLastNameValid,
            state.isEmailValid,
            state.isUsernameValid,
            state.isPasswordValid,
            state.isConfirmPasswordValid
        ).count { it }
        
        return validFields / 6.0
    }
}
