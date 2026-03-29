import XCTest
@testable import UniCoreValidation

final class MaxLengthRuleTests: XCTestCase {
    
    func testValidate_withInputShorterThanMaximum_returnsNoErrors() {
        let rule = MaxLengthRule(maxLength: 10)
        let result = rule.validate("hello")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withInputEqualToMaximum_returnsNoErrors() {
        let rule = MaxLengthRule(maxLength: 5)
        let result = rule.validate("hello")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withInputLongerThanMaximum_returnsError() {
        let rule = MaxLengthRule(maxLength: 5)
        let result = rule.validate("hello world")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.code, "maxLength")
        XCTAssertEqual(result.first?.messageKey, "validation.maxLength")
    }
    
    func testValidate_error_containsMetadata() {
        let rule = MaxLengthRule(maxLength: 5)
        let result = rule.validate("hello world")
        
        XCTAssertEqual(result.first?.metadata["maxLength"], "5")
        XCTAssertEqual(result.first?.metadata["currentLength"], "11")
    }
}
