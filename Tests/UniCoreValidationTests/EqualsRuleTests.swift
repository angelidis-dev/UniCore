import XCTest
@testable import UniCoreValidation

final class EqualsRuleTests: XCTestCase {
    
    func testValidate_withMatchingValue_returnsNoErrors() {
        let rule = EqualsRule(expectedValue: "password123")
        let result = rule.validate("password123")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withNonMatchingValue_returnsError() {
        let rule = EqualsRule(expectedValue: "password123")
        let result = rule.validate("wrongpassword")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.code, "equals")
        XCTAssertEqual(result.first?.messageKey, "validation.equals")
    }
    
    func testValidate_isCaseSensitive() {
        let rule = EqualsRule(expectedValue: "Test")
        XCTAssertTrue(rule.validate("test").isEmpty == false)
        XCTAssertTrue(rule.validate("Test").isEmpty)
    }
    
    func testValidate_withEmptyStrings() {
        let rule = EqualsRule(expectedValue: "")
        XCTAssertTrue(rule.validate("").isEmpty)
        XCTAssertTrue(rule.validate("nonempty").isEmpty == false)
    }
}
