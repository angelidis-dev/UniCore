import SwiftUI
import UniCoreValidation

/// ViewModel for comprehensive password validation
@Observable
final class PasswordValidationDemoViewModel {
    var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    
    var confirmPassword: String = "" {
        didSet {
            validateConfirmPassword()
        }
    }
    
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
    
    @ObservationIgnored
    private let confirmValidator = Validator(rules: [
        RequiredRule()
    ])
    
    var passwordErrors: [ValidationError] = []
    var confirmErrors: [ValidationError] = []
    var isPasswordValid: Bool = false
    var isConfirmValid: Bool = false
    var passwordStrength: PasswordStrength = .weak
    
    enum PasswordStrength {
        case weak
        case fair
        case good
        case strong
        
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
    
    func validatePassword() {
        let result = passwordValidator.validate(password)
        isPasswordValid = result.isValid
        passwordErrors = result.errors ?? []
        updatePasswordStrength()
    }
    
    func validateConfirmPassword() {
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
        
        // Length score
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        
        // Character variety
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

// MARK: - Password Requirements Checker
struct PasswordRequirements: View {
    let password: String
    
    var hasMinLength: Bool { password.count >= 8 }
    var hasMaxLength: Bool { password.count <= 128 }
    var hasUppercase: Bool { password.range(of: "[A-Z]", options: .regularExpression) != nil }
    var hasLowercase: Bool { password.range(of: "[a-z]", options: .regularExpression) != nil }
    var hasNumbers: Bool { password.range(of: "[0-9]", options: .regularExpression) != nil }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            RequirementRow(
                text: "At least 8 characters",
                met: hasMinLength
            )
            
            RequirementRow(
                text: "At most 128 characters",
                met: hasMaxLength
            )
            
            RequirementRow(
                text: "At least one uppercase letter (A-Z)",
                met: hasUppercase
            )
            
            RequirementRow(
                text: "At least one lowercase letter (a-z)",
                met: hasLowercase
            )
            
            RequirementRow(
                text: "At least one number (0-9)",
                met: hasNumbers
            )
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Requirement Row Component
struct RequirementRow: View {
    let text: String
    let met: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .foregroundColor(met ? .green : .gray)
                .font(.subheadline)
            
            Text(text)
                .font(.caption)
                .foregroundColor(met ? .primary : .secondary)
            
            Spacer()
        }
    }
}

// MARK: - Password Validation Demo View
struct PasswordValidationDemo: View {
    @State private var viewModel = PasswordValidationDemoViewModel()
    @State private var showPassword = false
    @State private var showConfirm = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Password Input
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Password", systemImage: "lock")
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text(viewModel.passwordStrength.label)
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Circle()
                                .fill(viewModel.passwordStrength.color)
                                .frame(width: 8, height: 8)
                        }
                        .foregroundColor(viewModel.passwordStrength.color)
                    }
                    
                    HStack {
                        if showPassword {
                            TextField("password", text: $viewModel.password)
                        } else {
                            SecureField("password", text: $viewModel.password)
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Password Requirements
                PasswordRequirements(password: viewModel.password)
                
                // Password errors
                if !viewModel.passwordErrors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.passwordErrors, id: \.code) { error in
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(error.messageKey)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    
                                    if !error.metadata.isEmpty {
                                        Text(error.metadata.map { "\($0.key): \($0.value)" }.joined(separator: " • "))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Confirm Password Input
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Confirm Password", systemImage: "lock.fill")
                            .font(.headline)
                        
                        if viewModel.isConfirmValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        }
                    }
                    
                    HStack {
                        if showConfirm {
                            TextField("confirm", text: $viewModel.confirmPassword)
                        } else {
                            SecureField("confirm", text: $viewModel.confirmPassword)
                        }
                        
                        Button(action: { showConfirm.toggle() }) {
                            Image(systemName: showConfirm ? "eye.slash" : "eye")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Confirm password errors
                if !viewModel.confirmErrors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.confirmErrors, id: \.code) { error in
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                
                                Text(error.messageKey)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .padding(12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Status indicator
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        StatusIndicator(
                            label: "Password",
                            isValid: viewModel.isPasswordValid
                        )
                        
                        StatusIndicator(
                            label: "Confirmation",
                            isValid: viewModel.isConfirmValid
                        )
                        
                        StatusIndicator(
                            label: "Strength",
                            isValid: viewModel.passwordStrength == .strong
                        )
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                Button(action: {}) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(viewModel.allValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.allValid)
                
                Spacer()
            }
            .padding(20)
        }
    }
}

// MARK: - Status Indicator Component
struct StatusIndicator: View {
    let label: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
                .font(.caption)
            
            Text(label)
                .font(.caption)
                .foregroundColor(isValid ? .primary : .secondary)
            
            Spacer()
        }
    }
}

#Preview {
    PasswordValidationDemo()
}
