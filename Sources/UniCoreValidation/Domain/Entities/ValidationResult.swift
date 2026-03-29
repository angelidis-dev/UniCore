/// Result of validation: either valid or invalid with associated errors
public enum ValidationResult: Equatable, Sendable {
    /// Input passes all validation rules
    case valid
    
    /// Input fails validation with one or more errors
    case invalid([ValidationError])
    
    /// Returns true if validation passed
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
    
    /// Returns errors if validation failed, nil otherwise
    public var errors: [ValidationError]? {
        if case .invalid(let errors) = self {
            return errors
        }
        return nil
    }
}
