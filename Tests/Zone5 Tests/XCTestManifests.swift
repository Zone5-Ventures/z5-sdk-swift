import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Zone5_Tests.allTests),
        testCase(Request_Tests.allTests),
    ]
}
#endif
