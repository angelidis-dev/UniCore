import SwiftUI
import UniCoreValidation

/// ViewModel for real-time email validation demo
@Observable
final class EmailValidationDemoViewModel {
    var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    
    @ObservationIgnored
    private let validator = Validator(rules: [
        RequiredRule(),
        EmailRule()
    ])
    
    var validationError: ValidationError?
    var isValid: Bool = false
    
    func validateEmail() {
        let result = validator.validate(email)
        isValid = result.isValid
        validationError = result.errors?.first
    }
}

/// Real-time email validation input with visual feedback
struct EmailValidationDemo: View {
    @State private var viewModel = EmailValidationDemoViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Label("Email", systemImage: "envelope")
                    .font(.headline)
                
                HStack {
                    TextField("enter@email.com", text: $viewModel.email)
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
            
            // Error display
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
                        
                        if let details = error.metadata.map({ "\($0.key): \($0.value)" }).joined(separator: " • ") {
                            Text(details)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    EmailValidationDemo()
}
