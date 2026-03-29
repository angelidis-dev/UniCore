import XCTest
@testable import UniCoreValidation

final class EmailRuleTests: XCTestCase {
    
    var rule: EmailRule!
    
    override func setUp() {
        super.setUp()
        rule = EmailRule()
    }
    
    func testValidate_withValidEmail_returnsNoErrors() {
        XCTAssertTrue(rule.validate("user@example.com").isEmpty)
        XCTAssertTrue(rule.validate("test.user+tag@domain.co.uk").isEmpty)
        XCTAssertTrue(rule.validate("first.last@subdomain.example.org").isEmpty)
    }
    
    func testValidate_withInvalidEmail_returnsError() {
        let invalidEmails = [
            "plainaddress",
            "@nodomain.com",
            "user@",
            "user name@example.com",
            "user@domain",
            "user@.com",
            "user@@example.com",
        ]
        
        for email in invalidEmails {
            let result = rule.validate(email)
            XCTAssertEqual(result.count, 1, "Expected error for email: \(email)")
            XCTAssertEqual(result.first?.code, "email.invalid")
            XCTAssertEqual(result.first?.messageKey, "validation.email.invalid")
        }
    }
    
    func testValidate_withEmptyString_returnsError() {
        let result = rule.validate("")
        XCTAssertEqual(result.count, 1)
    }
    
    func testValidate_withEmailHavingNumbers_returnsNoErrors() {
        XCTAssertTrue(rule.validate("user123@test456.com").isEmpty)
    }
}
