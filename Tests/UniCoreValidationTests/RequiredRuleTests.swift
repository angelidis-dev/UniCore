import XCTest
@testable import UniCoreValidation

final class RequiredRuleTests: XCTestCase {
    
    var rule: RequiredRule!
    
    override func setUp() {
        super.setUp()
        rule = RequiredRule()
    }
    
    func testValidate_withNonEmptyInput_returnsNoErrors() {
        let result = rule.validate("test input")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testValidate_withEmptyString_returnsError() {
        let result = rule.validate("")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.code, "required")
        XCTAssertEqual(result.first?.messageKey, "validation.required")
    }
    
    func testValidate_withOnlyWhitespace_returnsError() {
        let result = rule.validate("   ")
        XCTAssertEqual(result.count, 1)
    }
    
    func testValidate_withTabsAndNewlines_returnsError() {
        let result = rule.validate("\t\n  ")
        XCTAssertEqual(result.count, 1)
    }
    
    func testValidate_withTextAndWhitespace_returnsNoErrors() {
        let result = rule.validate("  test  ")
        XCTAssertTrue(result.isEmpty)
    }
}
