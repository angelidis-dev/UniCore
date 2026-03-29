import XCTest
@testable import UniCoreValidation

final class RegexValidatorTests: XCTestCase {
    
    func testIsMatch_withValidPattern_returnsTrue() {
        let validator = RegexValidator(pattern: "^[a-z]+$")
        XCTAssertTrue(validator.isMatch("hello"))
    }
    
    func testIsMatch_withInvalidPattern_returnsFalse() {
        let validator = RegexValidator(pattern: "^[a-z]+$")
        XCTAssertFalse(validator.isMatch("hello123"))
    }
    
    func testIsMatch_withDigitPattern_correctlyMatches() {
        let validator = RegexValidator(pattern: "^\\d{3}-\\d{4}$")
        XCTAssertTrue(validator.isMatch("123-4567"))
        XCTAssertFalse(validator.isMatch("12-4567"))
    }
    
    func testIsMatch_withEmptyString_returnsFalse() {
        let validator = RegexValidator(pattern: "^.+$")
        XCTAssertFalse(validator.isMatch(""))
    }
    
    func testIsMatch_withInvalidRegex_returnsFalse() {
        let validator = RegexValidator(pattern: "[invalid(regex")
        XCTAssertFalse(validator.isMatch("test"))
    }
}

final class RegexRuleTests: XCTestCase {
    
    func testValidate_withMatchingPattern_returnsNoErrors() {
        let rule = RegexRule(
            pattern: "^[0-9]{3}-[0-9]{3}-[0-9]{4}$",
            code: "phone.invalid",
            messageKey: "validation.phone.invalid"
        )
        let result = rule.validate("123-456-7890")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withNonMatchingPattern_returnsError() {
        let rule = RegexRule(
            pattern: "^[0-9]{3}-[0-9]{3}-[0-9]{4}$",
            code: "phone.invalid",
            messageKey: "validation.phone.invalid"
        )
        let result = rule.validate("invalid")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.code, "phone.invalid")
        XCTAssertEqual(result.first?.messageKey, "validation.phone.invalid")
    }
}
