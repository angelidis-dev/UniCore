import XCTest
@testable import UniCoreValidation

final class ValidationErrorTests: XCTestCase {
    
    func testInitialization_withCode_messageKey_andMetadata() {
        let metadata = ["key": "value"]
        let error = ValidationError(
            code: "test.error",
            messageKey: "validation.test",
            metadata: metadata
        )
        
        XCTAssertEqual(error.code, "test.error")
        XCTAssertEqual(error.messageKey, "validation.test")
        XCTAssertEqual(error.metadata, metadata)
    }
    
    func testInitialization_withoutMetadata_defaultsToEmpty() {
        let error = ValidationError(
            code: "test.error",
            messageKey: "validation.test"
        )
        
        XCTAssertEqual(error.metadata, [:])
    }
    
    func testEquality_twoErrorsWithSameValues_areEqual() {
        let error1 = ValidationError(code: "test", messageKey: "test.key")
        let error2 = ValidationError(code: "test", messageKey: "test.key")
        
        XCTAssertEqual(error1, error2)
    }
    
    func testEquality_twoErrorsWithDifferentCode_areNotEqual() {
        let error1 = ValidationError(code: "test1", messageKey: "test.key")
        let error2 = ValidationError(code: "test2", messageKey: "test.key")
        
        XCTAssertNotEqual(error1, error2)
    }
}
