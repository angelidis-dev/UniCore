import XCTest
@testable import UniCoreValidation

final class ValidationResultTests: XCTestCase {
    
    func testValid_isValid_returnsTrue() {
        let result = ValidationResult.valid
        XCTAssertTrue(result.isValid)
    }
    
    func testInvalid_isValid_returnsFalse() {
        let error = ValidationError(code: "test", messageKey: "test.key")
        let result = ValidationResult.invalid([error])
        XCTAssertFalse(result.isValid)
    }
    
    func testValid_errors_returnsNil() {
        let result = ValidationResult.valid
        XCTAssertNil(result.errors)
    }
    
    func testInvalid_errors_returnsErrors() {
        let error1 = ValidationError(code: "test1", messageKey: "test.key1")
        let error2 = ValidationError(code: "test2", messageKey: "test.key2")
        let result = ValidationResult.invalid([error1, error2])
        
        XCTAssertEqual(result.errors, [error1, error2])
    }
    
    func testEquality_twoValidResults_areEqual() {
        let result1 = ValidationResult.valid
        let result2 = ValidationResult.valid
        XCTAssertEqual(result1, result2)
    }
    
    func testEquality_twoInvalidResultsWithSameErrors_areEqual() {
        let error = ValidationError(code: "test", messageKey: "test.key")
        let result1 = ValidationResult.invalid([error])
        let result2 = ValidationResult.invalid([error])
        XCTAssertEqual(result1, result2)
    }
}
