/// Represents a validation error with structured information
/// - code: Machine-readable error code (e.g., "email.invalid")
/// - messageKey: Localization key for user-facing messages (e.g., "validation.email.invalid")
/// - metadata: Additional context (e.g., ["field": "email", "min_length": "5"])
public struct ValidationError: Equatable, Sendable {
    /// Machine-readable error identifier
    public let code: String
    
    /// Localization key for message rendering
    public let messageKey: String
    
    /// Additional context data for error handling
    public let metadata: [String: String]

    /// Initializes a ValidationError with code, messageKey, and optional metadata
    public init(
        code: String,
        messageKey: String,
        metadata: [String: String] = [:]
    ) {
        self.code = code
        self.messageKey = messageKey
        self.metadata = metadata
    }
}
