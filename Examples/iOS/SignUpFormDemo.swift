import SwiftUI
import UniCoreValidation

/// Comprehensive sign-up form with multiple field validation
@Observable
final class SignUpFormViewModel {
    var firstName: String = "" {
        didSet { validateFirstName() }
    }
    
    var lastName: String = "" {
        didSet { validateLastName() }
    }
    
    var email: String = "" {
        didSet { validateEmail() }
    }
    
    var username: String = "" {
        didSet { validateUsername() }
    }
    
    var password: String = "" {
        didSet { validatePassword() }
    }
    
    var confirmPassword: String = "" {
        didSet { validateConfirmPassword() }
    }
    
    // MARK: - Validation State
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
    
    // MARK: - Validators
    @ObservationIgnored
    private let firstNameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 2),
        MaxLengthRule(maxLength: 50)
    ])
    
    @ObservationIgnored
    private let lastNameValidator = Validator(rules: [
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
    private lazy var usernameValidator = Validator(rules: [
        RequiredRule(),
        MinLengthRule(minLength: 3),
        MaxLengthRule(maxLength: 20),
        RegexRule(
            pattern: "^[a-zA-Z0-9_-]+$",
            code: "username.invalid",
            messageKey: "validation.username.alphanumericOnly"
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
            messageKey: "validation.password.requiresUpperLowerNumber"
        )
    ])
    
    // MARK: - Validation Methods
    private func validateFirstName() {
        let result = firstNameValidator.validate(firstName)
        isFirstNameValid = result.isValid
        firstNameError = result.errors?.first
    }
    
    private func validateLastName() {
        let result = lastNameValidator.validate(lastName)
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

// MARK: - Form Field Component
struct FormField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let error: ValidationError?
    let isValid: Bool
    let isSecure: Bool
    @State private var showSecure = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(label, systemImage: icon)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if isValid && !text.isEmpty {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            HStack {
                if isSecure && showSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                }
                
                if isSecure {
                    Button(action: { showSecure.toggle() }) {
                        Image(systemName: showSecure ? "eye.slash" : "eye")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            
            if let error = error, !text.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(error.messageKey)
                            .font(.caption2)
                            .fontWeight(.semibold)
                        
                        if let details = error.metadata.map({ "\($0.key): \($0.value)" }).joined(separator: " • "), !details.isEmpty {
                            Text(details)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }
}

// MARK: - Progress Indicator
struct FormProgressView: View {
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Form Completion")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(Int(percentage * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Color(.systemGray5)
                    
                    Color.blue
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
    }
}

// MARK: - Main Sign-Up Form View
struct SignUpFormDemo: View {
    @State private var viewModel = SignUpFormViewModel()
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Sign up for UniCore Validation Demo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Progress
                    FormProgressView(percentage: viewModel.completionPercentage)
                    
                    // Personal Info Section
                    VStack(spacing: 14) {
                        Text("Personal Information")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        FormField(
                            label: "First Name",
                            icon: "person",
                            placeholder: "John",
                            text: $viewModel.firstName,
                            error: viewModel.firstNameError,
                            isValid: viewModel.isFirstNameValid,
                            isSecure: false
                        )
                        
                        FormField(
                            label: "Last Name",
                            icon: "person.fill",
                            placeholder: "Doe",
                            text: $viewModel.lastName,
                            error: viewModel.lastNameError,
                            isValid: viewModel.isLastNameValid,
                            isSecure: false
                        )
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Account Info Section
                    VStack(spacing: 14) {
                        Text("Account Information")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        FormField(
                            label: "Email",
                            icon: "envelope",
                            placeholder: "user@example.com",
                            text: $viewModel.email,
                            error: viewModel.emailError,
                            isValid: viewModel.isEmailValid,
                            isSecure: false
                        )
                        
                        FormField(
                            label: "Username",
                            icon: "at",
                            placeholder: "john_doe",
                            text: $viewModel.username,
                            error: viewModel.usernameError,
                            isValid: viewModel.isUsernameValid,
                            isSecure: false
                        )
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Security Section
                    VStack(spacing: 14) {
                        Text("Security")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        FormField(
                            label: "Password",
                            icon: "lock",
                            placeholder: "••••••••",
                            text: $viewModel.password,
                            error: viewModel.passwordError,
                            isValid: viewModel.isPasswordValid,
                            isSecure: true
                        )
                        
                        FormField(
                            label: "Confirm Password",
                            icon: "lock.fill",
                            placeholder: "••••••••",
                            text: $viewModel.confirmPassword,
                            error: viewModel.confirmPasswordError,
                            isValid: viewModel.isConfirmPasswordValid,
                            isSecure: true
                        )
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Actions
                    VStack(spacing: 10) {
                        Button(action: { showSuccessAlert = true }) {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(viewModel.isFormValid ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .fontWeight(.semibold)
                        }
                        .disabled(!viewModel.isFormValid)
                        
                        NavigationLink(destination: Text("Account created!")) {
                            Text("Already have an account?")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK") { }
            } message: {
                Text("Account created successfully!")
            }
        }
    }
}

#Preview {
    SignUpFormDemo()
}
