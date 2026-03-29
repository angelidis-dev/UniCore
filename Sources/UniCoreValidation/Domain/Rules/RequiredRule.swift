import Foundation

/// Validates that input is not empty
public struct RequiredRule: ValidationRule {
    private let code = "required"
    private let messageKey = "validation.required"
    
    public init() {}
    
    public func validate(_ input: String) -> [ValidationError] {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return [ValidationError(code: code, messageKey: messageKey)]
        }
        return []
    }
}
