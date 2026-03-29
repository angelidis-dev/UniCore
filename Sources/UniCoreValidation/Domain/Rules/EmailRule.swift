import Foundation

/// Validates email format according to RFC 5322 simplified pattern
public struct EmailRule: ValidationRule {
    private let regex: RegexValidator
    private let code = "email.invalid"
    private let messageKey = "validation.email.invalid"
    
    // Simplified RFC 5322 email pattern
    private static let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
    
    public init() {
        self.regex = RegexValidator(pattern: Self.emailPattern)
    }
    
    public func validate(_ input: String) -> [ValidationError] {
        if !regex.isMatch(input) {
            return [ValidationError(code: code, messageKey: messageKey)]
        }
        return []
    }
}
