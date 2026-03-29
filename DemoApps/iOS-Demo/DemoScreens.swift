// DemoScreens.swift
// All demo screens in one file for easy reference

import SwiftUI
import UniCoreValidation

// MARK: - Email Validation Demo

struct EmailValidationDemoView: View {
    @State private var viewModel = EmailValidationDemoViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Real-Time Email Validation")
                        .font(.headline)
                    
                    Text("Type an email and see validation in action")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Email Address", systemImage: "envelope")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        TextField("user@example.com", text: $viewModel.email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        if viewModel.isValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                    }
                }
                .padding(.horizontal)
                
                if let error = viewModel.validationError {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Validation Error")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Text(error.messageKey)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("Email Validation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Password Validation Demo

struct PasswordValidationDemoView: View {
    @State private var viewModel = PasswordValidationDemoViewModel()
    @State private var showPassword = false
    @State private var showConfirm = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password Validation")
                        .font(.headline)
                    
                    Text("Create a strong password with real-time feedback")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Password Input
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Password", systemImage: "lock")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
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
                .padding(.horizontal)
                
                // Confirm Password
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Confirm", systemImage: "lock.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if viewModel.isConfirmValid {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
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
                .padding(.horizontal)
                
                // Status
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        StatusRow("Password Valid", viewModel.isPasswordValid)
                        StatusRow("Confirmed", viewModel.isConfirmValid)
                        StatusRow("Strong Password", viewModel.passwordStrength == .strong)
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button(action: {}) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(viewModel.allValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.allValid)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("Password Validation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Sign-Up Form Demo

struct SignUpFormDemoView: View {
    @State private var viewModel = SignUpFormDemoViewModel()
    @State private var showSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Form completion: \(Int(viewModel.completionPercentage * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Color(.systemGray5)
                        
                        Color.blue
                            .frame(width: geometry.size.width * viewModel.completionPercentage)
                    }
                }
                .frame(height: 8)
                .cornerRadius(4)
                .padding(.horizontal)
                
                // Personal Info
                VStack(spacing: 12) {
                    Text("Personal Information")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FormFieldView(
                        label: "First Name",
                        placeholder: "John",
                        text: $viewModel.firstName,
                        error: viewModel.firstNameError,
                        isValid: viewModel.isFirstNameValid
                    )
                    
                    FormFieldView(
                        label: "Last Name",
                        placeholder: "Doe",
                        text: $viewModel.lastName,
                        error: viewModel.lastNameError,
                        isValid: viewModel.isLastNameValid
                    )
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Account Info
                VStack(spacing: 12) {
                    Text("Account Information")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FormFieldView(
                        label: "Email",
                        placeholder: "user@example.com",
                        text: $viewModel.email,
                        error: viewModel.emailError,
                        isValid: viewModel.isEmailValid
                    )
                    
                    FormFieldView(
                        label: "Username",
                        placeholder: "john_doe",
                        text: $viewModel.username,
                        error: viewModel.usernameError,
                        isValid: viewModel.isUsernameValid
                    )
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Security
                VStack(spacing: 12) {
                    Text("Security")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FormFieldView(
                        label: "Password",
                        placeholder: "••••••••",
                        text: $viewModel.password,
                        error: viewModel.passwordError,
                        isValid: viewModel.isPasswordValid
                    )
                    
                    FormFieldView(
                        label: "Confirm Password",
                        placeholder: "••••••••",
                        text: $viewModel.confirmPassword,
                        error: viewModel.confirmPasswordError,
                        isValid: viewModel.isConfirmPasswordValid
                    )
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button(action: { showSuccess = true }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(viewModel.isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.isFormValid)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("Sign-Up Form")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Success!", isPresented: $showSuccess) {
            Button("Done") { }
        } message: {
            Text("Account created successfully!")
        }
    }
}

// MARK: - Helper Components

struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let error: ValidationError?
    let isValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if isValid && !text.isEmpty {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color(.white))
                .cornerRadius(6)
            
            if let error = error, !text.isEmpty {
                Text(error.messageKey)
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

struct StatusRow: View {
    let label: String
    let isValid: Bool
    
    init(_ label: String, _ isValid: Bool) {
        self.label = label
        self.isValid = isValid
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
                .font(.caption)
            
            Text(label)
                .font(.caption)
            
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Email") {
    NavigationStack {
        EmailValidationDemoView()
    }
}

#Preview("Password") {
    NavigationStack {
        PasswordValidationDemoView()
    }
}

#Preview("SignUp") {
    NavigationStack {
        SignUpFormDemoView()
    }
}
