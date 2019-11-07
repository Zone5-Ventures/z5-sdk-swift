import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Zone5Tests.allTests),
        testCase(RequestTests.allTests),
		testCase(UsersViewTests.allTests),
    ]
}
#endif
