import Foundation

/// Validates that input has minimum required length
public struct MinLengthRule: ValidationRule {
    private let minLength: Int
    private let code = "minLength"
    private let messageKey = "validation.minLength"
    
    /// Initializes MinLengthRule with minimum required length
    public init(minLength: Int) {
        self.minLength = minLength
    }
    
    public func validate(_ input: String) -> [ValidationError] {
        if input.count < minLength {
            return [
                ValidationError(
                    code: code,
                    messageKey: messageKey,
                    metadata: ["minLength": String(minLength), "currentLength": String(input.count)]
                )
            ]
        }
        return []
    }
}
