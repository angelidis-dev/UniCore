/// Protocol for validation rules
/// Each rule is single-responsibility and returns errors if validation fails
public protocol ValidationRule: Sendable {
    /// Validates input and returns any validation errors
    /// - Parameter input: String to validate
    /// - Returns: Empty array if valid, array of ValidationError otherwise
    func validate(_ input: String) -> [ValidationError]
}
