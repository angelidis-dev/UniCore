import XCTest
@testable import UniCoreValidation

final class ValidatorTests: XCTestCase {
    
    func testValidate_withNoRules_returnsValid() {
        let validator = Validator(rules: [])
        let result = validator.validate("any input")
        XCTAssertTrue(result.isValid)
    }
    
    func testValidate_withSingleValidRule_returnsValid() {
        let rule = RequiredRule()
        let validator = Validator(rules: [rule])
        let result = validator.validate("test")
        XCTAssertTrue(result.isValid)
    }
    
    func testValidate_withSingleFailingRule_returnsInvalid() {
        let rule = RequiredRule()
        let validator = Validator(rules: [rule])
        let result = validator.validate("")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors?.count, 1)
        XCTAssertEqual(result.errors?.first?.code, "required")
    }
    
    func testValidate_withMultipleRulesSingleFailure_returnsErrorForFailingRule() {
        let rules: [any ValidationRule] = [
            RequiredRule(),
            MinLengthRule(minLength: 5)
        ]
        let validator = Validator(rules: rules)
        let result = validator.validate("hi")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors?.count, 1)
        XCTAssertEqual(result.errors?.first?.code, "minLength")
    }
    
    func testValidate_withMultipleFailingRules_returnsAllErrors() {
        let rules: [any ValidationRule] = [
            MinLengthRule(minLength: 10),
            MaxLengthRule(maxLength: 5)
        ]
        let validator = Validator(rules: rules)
        let result = validator.validate("hello")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors?.count, 1) // Only maxLength fails
        
        let rules2: [any ValidationRule] = [
            MinLengthRule(minLength: 10),
            MaxLengthRule(maxLength: 5)
        ]
        let validator2 = Validator(rules: rules2)
        let result2 = validator2.validate("toolong")
        
        XCTAssertFalse(result2.isValid)
        XCTAssertEqual(result2.errors?.count, 2) // Both fail (7 chars < minLength 10, 7 chars > maxLength 5)
    }
}

// MARK: - Integration Tests

final class EmailValidationIntegrationTests: XCTestCase {
    
    func testValidateEmail_withValidEmail_returnsValid() {
        let validator = Validator(rules: [
            RequiredRule(),
            EmailRule()
        ])
        
        let result = validator.validate("user@example.com")
        XCTAssertTrue(result.isValid)
    }
    
    func testValidateEmail_withEmptyEmail_returnsRequiredError() {
        let validator = Validator(rules: [
            RequiredRule(),
            EmailRule()
        ])
        
        let result = validator.validate("")
        XCTAssertFalse(result.isValid)
        // Empty string fails both required and email rules
        XCTAssertEqual(result.errors?.count, 2)
        XCTAssertEqual(result.errors?.first?.code, "required")
    }
    
    func testValidateEmail_withInvalidEmail_returnsEmailError() {
        let validator = Validator(rules: [
            RequiredRule(),
            EmailRule()
        ])
        
        let result = validator.validate("invalid-email")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors?.count, 1)
        XCTAssertEqual(result.errors?.first?.code, "email.invalid")
    }
}

final class PasswordValidationIntegrationTests: XCTestCase {
    
    func testValidatePassword_withStrongPassword_returnsValid() {
        let validator = Validator(rules: [
            RequiredRule(),
            MinLengthRule(minLength: 8),
            MaxLengthRule(maxLength: 128)
        ])
        
        let result = validator.validate("securePassword123")
        XCTAssertTrue(result.isValid)
    }
    
    func testValidatePassword_tooShort_returnsMinLengthError() {
        let validator = Validator(rules: [
            RequiredRule(),
            MinLengthRule(minLength: 8),
            MaxLengthRule(maxLength: 128)
        ])
        
        let result = validator.validate("short")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors?.count, 1)
        XCTAssertEqual(result.errors?.first?.code, "minLength")
    }
    
    func testValidateUsername_withComplexRules_validatesCorrectly() {
        let alphanumericRule = RegexRule(
            pattern: "^[a-zA-Z0-9_-]+$",
            code: "username.invalid",
            messageKey: "validation.username.invalid"
        )
        
        let validator = Validator(rules: [
            RequiredRule(),
            MinLengthRule(minLength: 3),
            MaxLengthRule(maxLength: 20),
            alphanumericRule
        ])
        
        XCTAssertTrue(validator.validate("valid_user-123").isValid)
        XCTAssertFalse(validator.validate("u!").isValid)
        XCTAssertFalse(validator.validate("user@domain").isValid)
    }
}
