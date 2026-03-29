/// Orchestrates multiple validation rules and produces final validation result
public struct Validator: Sendable {
    private let rules: [any ValidationRule]
    
    /// Initializes Validator with array of validation rules
    public init(rules: [any ValidationRule]) {
        self.rules = rules
    }
    
    /// Validates input by running all rules and combining errors
    public func validate(_ input: String) -> ValidationResult {
        let errors = rules.flatMap { $0.validate(input) }
        return errors.isEmpty ? .valid : .invalid(errors)
    }
}
