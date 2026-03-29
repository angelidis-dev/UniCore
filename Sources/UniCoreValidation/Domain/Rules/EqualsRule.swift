import Foundation

/// Validates that input equals a specific value
public struct EqualsRule: ValidationRule {
    private let expectedValue: String
    private let code = "equals"
    private let messageKey = "validation.equals"
    
    /// Initializes EqualsRule with expected value
    public init(expectedValue: String) {
        self.expectedValue = expectedValue
    }
    
    public func validate(_ input: String) -> [ValidationError] {
        if input != expectedValue {
            return [ValidationError(code: code, messageKey: messageKey)]
        }
        return []
    }
}
