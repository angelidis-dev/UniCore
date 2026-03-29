import Foundation

/// Regex-based validation helper
public struct RegexValidator: Sendable {
    private let pattern: String
    private let options: NSRegularExpression.Options
    
    /// Initializes RegexValidator with a regex pattern
    public init(pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }
    
    /// Tests if input matches the regex pattern
    public func isMatch(_ input: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let range = NSRange(input.startIndex..., in: input)
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
}

/// Validates input against a custom regex pattern
public struct RegexRule: ValidationRule {
    private let regex: RegexValidator
    private let code: String
    private let messageKey: String
    
    /// Initializes RegexRule with pattern, code, and messageKey
    public init(pattern: String, code: String, messageKey: String) {
        self.regex = RegexValidator(pattern: pattern)
        self.code = code
        self.messageKey = messageKey
    }
    
    public func validate(_ input: String) -> [ValidationError] {
        if !regex.isMatch(input) {
            return [ValidationError(code: code, messageKey: messageKey)]
        }
        return []
    }
}
