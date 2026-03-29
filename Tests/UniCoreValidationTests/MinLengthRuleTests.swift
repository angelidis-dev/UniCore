import XCTest
@testable import UniCoreValidation

final class MinLengthRuleTests: XCTestCase {
    
    func testValidate_withInputLongerThanMinimum_returnsNoErrors() {
        let rule = MinLengthRule(minLength: 5)
        let result = rule.validate("hello world")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withInputEqualToMinimum_returnsNoErrors() {
        let rule = MinLengthRule(minLength: 5)
        let result = rule.validate("hello")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withInputShorterThanMinimum_returnsError() {
        let rule = MinLengthRule(minLength: 5)
        let result = rule.validate("hi")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.code, "minLength")
        XCTAssertEqual(result.first?.messageKey, "validation.minLength")
    }
    
    func testValidate_error_containsMetadata() {
        let rule = MinLengthRule(minLength: 8)
        let result = rule.validate("short")
        
        XCTAssertEqual(result.first?.metadata["minLength"], "8")
        XCTAssertEqual(result.first?.metadata["currentLength"], "5")
    }
    
    func testValidate_withMinLengthZero() {
        let rule = MinLengthRule(minLength: 0)
        let result = rule.validate("")
        XCTAssertTrue(result.isEmpty)
    }
}
