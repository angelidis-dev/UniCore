// ViewModels.swift
// All view models for the demo app

import SwiftUI
import UniCoreValidation

// MARK: - Email Validation ViewModel

@Observable
final class EmailValidationDemoViewModel {
    var email: String = "" {
        didSet { validateEmail() }
    }
    
    @ObservationIgnored
    private let validator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    var validationError: ValidationError?
    var isValid: Bool = false
    
    private func validateEmail() {
        let result = validator.validate(email)
        isValid = result.isValid
        validationError = result.errors?.first
    }
}

// MARK: - Password Validation ViewModel

@Observable
final class PasswordValidationDemoViewModel {
    var password: String = "" {
        didSet { validatePassword() }
    }
    
    var confirmPassword: String = "" {
        didSet { validateConfirmPassword() }
    }
    
    @ObservationIgnored
    private let passwordValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 8),
        MaxLengthRule(maxLength: 128),
        RegexRule(
            pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
            code: "password.weak",
            messageKey: "validation.password.weak"
        )
    ])
    
    var passwordErrors: [ValidationError] = []
    var confirmErrors: [ValidationError] = []
    var isPasswordValid: Bool = false
    var isConfirmValid: Bool = false
    var passwordStrength: PasswordStrength = .weak
    
    enum PasswordStrength {
        case weak, fair, good, strong
        
        var color: Color {
            switch self {
            case .weak: return .red
            case .fair: return .orange
            case .good: return .yellow
            case .strong: return .green
            }
        }
        
        var label: String {
            switch self {
            case .weak: return "Weak"
            case .fair: return "Fair"
            case .good: return "Good"
            case .strong: return "Strong"
            }
        }
    }
    
    private func validatePassword() {
        let result = passwordValidator.validate(password)
        isPasswordValid = result.isValid
        passwordErrors = result.errors ?? []
        updatePasswordStrength()
        validateConfirmPassword()
    }
    
    private func validateConfirmPassword() {
        let matchValidator = Validator(rules: [
            RequiredRule(),
            EqualsRule(expectedValue: password)
        ])
        
        let result = matchValidator.validate(confirmPassword)
        isConfirmValid = result.isValid
        confirmErrors = result.errors ?? []
    }
    
    private func updatePasswordStrength() {
        guard !password.isEmpty else {
            passwordStrength = .weak
            return
        }
        
        var score = 0
        
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumbers = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil
        
        if hasLowercase { score += 1 }
        if hasUppercase { score += 1 }
        if hasNumbers { score += 1 }
        if hasSpecial { score += 1 }
        
        switch score {
        case 0...2:
            passwordStrength = .weak
        case 3:
            passwordStrength = .fair
        case 4:
            passwordStrength = .good
        default:
            passwordStrength = .strong
        }
    }
    
    var allValid: Bool {
        isPasswordValid && isConfirmValid && passwordStrength == .strong
    }
}

// MARK: - Sign-Up Form ViewModel

@Observable
final class SignUpFormDemoViewModel {
    var firstName: String = "" { didSet { validateFirstName() } }
    var lastName: String = "" { didSet { validateLastName() } }
    var email: String = "" { didSet { validateEmail() } }
    var username: String = "" { didSet { validateUsername() } }
    var password: String = "" { didSet { validatePassword() } }
    var confirmPassword: String = "" { didSet { validateConfirmPassword() } }
    
    var firstNameError: ValidationError?
    var lastNameError: ValidationError?
    var emailError: ValidationError?
    var usernameError: ValidationError?
    var passwordError: ValidationError?
    var confirmPasswordError: ValidationError?
    
    var isFirstNameValid = false
    var isLastNameValid = false
    var isEmailValid = false
    var isUsernameValid = false
    var isPasswordValid = false
    var isConfirmPasswordValid = false
    
    @ObservationIgnored
    private let nameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 2),
        MaxLengthRule(maxLength: 50)
    ])
    
    @ObservationIgnored
    private let emailValidator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    @ObservationIgnored
    private let usernameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 3),
        MaxLengthRule(maxLength: 20),
        RegexRule(
            pattern: "^[a-zA-Z0-9_-]+$",
            code: "username.invalid",
            messageKey: "validation.username.alphanumeric"
        )
    ])
    
    @ObservationIgnored
    private let passwordValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 8),
        MaxLengthRule(maxLength: 128),
        RegexRule(
            pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
            code: "password.weak",
            messageKey: "validation.password.weak"
        )
    ])
    
    private func validateFirstName() {
        let result = nameValidator.validate(firstName)
        isFirstNameValid = result.isValid
        firstNameError = result.errors?.first
    }
    
    private func validateLastName() {
        let result = nameValidator.validate(lastName)
        isLastNameValid = result.isValid
        lastNameError = result.errors?.first
    }
    
    private func validateEmail() {
        let result = emailValidator.validate(email)
        isEmailValid = result.isValid
        emailError = result.errors?.first
    }
    
    private func validateUsername() {
        let result = usernameValidator.validate(username)
        isUsernameValid = result.isValid
        usernameError = result.errors?.first
    }
    
    private func validatePassword() {
        let result = passwordValidator.validate(password)
        isPasswordValid = result.isValid
        passwordError = result.errors?.first
    }
    
    private func validateConfirmPassword() {
        let matchValidator = Validator(rules: [
            RequiredRule(),
            EqualsRule(expectedValue: password)
        ])
        
        let result = matchValidator.validate(confirmPassword)
        isConfirmPasswordValid = result.isValid
        confirmPasswordError = result.errors?.first
    }
    
    var isFormValid: Bool {
        isFirstNameValid && isLastNameValid && isEmailValid &&
        isUsernameValid && isPasswordValid && isConfirmPasswordValid
    }
    
    var completionPercentage: Double {
        let validFields = [
            isFirstNameValid, isLastNameValid, isEmailValid,
            isUsernameValid, isPasswordValid, isConfirmPasswordValid
        ].filter { $0 }.count
        
        return Double(validFields) / 6.0
    }
}
