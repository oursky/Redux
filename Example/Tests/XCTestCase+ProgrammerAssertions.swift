//
//  ProgrammerAssertions.swift
//  Redux
//
//  Created by Steven Chan on 4/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//
import Foundation
import XCTest
@testable import Redux

private let noReturnFailureWaitTime = 0.1

// swiftlint:disable line_length
public extension XCTestCase {

    /**
    Expects an `fatalError` to be called.
    If `fatalError` not called, the test case will fail.

    - parameter expectedMessage: The expected message to be asserted to the one passed to the `fatalError`. If nil, then ignored.
    - parameter file:            The file name that called the method.
    - parameter line:            The line number that called the method.
    - parameter testCase:        The test case to be executed that expected to fire the assertion method.
    */
    public func expectFatalError(
        expectedMessage: String? = nil,
        file: StaticString = __FILE__,
        line: UInt = __LINE__,
        testCase: () -> Void) {

            expectAssertionNoReturnFunction("fatalError", file: file, line: line, function: { (caller) -> () in

                Assertions.fatalErrorClosure = { message, _, _ in
                    caller(message)
                }

                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.fatalErrorClosure = Assertions.swiftFatalErrorClosure
            }
    }

    // MARK:- Private Methods
    private func expectAssertionNoReturnFunction(
        functionName: String,
        file: StaticString,
        line: UInt,
        function: (caller: (String) -> Void) -> Void,
        expectedMessage: String? = nil,
        testCase: () -> Void,
        cleanUp: () -> ()
        ) {

            let expectation = expectationWithDescription(functionName + "-Expectation")
            var assertionMessage: String? = nil

            function { (message) -> Void in
                assertionMessage = message
                expectation.fulfill()
            }

            // act, perform on separate thead because a call to function runs forever
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), testCase)

            waitForExpectationsWithTimeout(noReturnFailureWaitTime) { _ in

                defer {
                    // clean up
                    cleanUp()
                }

                guard let assertionMessage = assertionMessage else {
                    XCTFail(functionName + " is expected to be called.", file: file.stringValue, line: line)
                    return
                }

                if let expectedMessage = expectedMessage {
                    // assert only if not nil
                    XCTAssertEqual(assertionMessage, expectedMessage, functionName + " called with incorrect message.", file: file.stringValue, line: line)
                }
            }
    }
}
// swiftlint:enable line_length
