import Foundation

/// Validates that input does not exceed maximum length
public struct MaxLengthRule: ValidationRule {
    private let maxLength: Int
    private let code = "maxLength"
    private let messageKey = "validation.maxLength"
    
    /// Initializes MaxLengthRule with maximum allowed length
    public init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    public func validate(_ input: String) -> [ValidationError] {
        if input.count > maxLength {
            return [
                ValidationError(
                    code: code,
                    messageKey: messageKey,
                    metadata: ["maxLength": String(maxLength), "currentLength": String(input.count)]
                )
            ]
        }
        return []
    }
}
