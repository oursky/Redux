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
        _ expectedMessage: String? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        testCase: @escaping () -> Void) {

            expectAssertionNoReturnFunction("fatalError", file: file, line: line, function: { (caller) -> () in

                Assertions.fatalErrorClosure = { message, _, _ in
                    caller(message)
                }

                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.fatalErrorClosure = Assertions.swiftFatalErrorClosure
            }
    }

    // MARK:- Private Methods
    fileprivate func expectAssertionNoReturnFunction(
        _ functionName: String,
        file: StaticString,
        line: UInt,
        function: (_ caller: @escaping (String) -> Never) -> Void,
        expectedMessage: String? = nil,
        testCase: @escaping () -> Void,
        cleanUp: @escaping () -> ()
        ) {

            let expectation = self.expectation(description: functionName + "-Expectation")
            var assertionMessage: String? = nil

            function { (message) -> Never in
                assertionMessage = message
                expectation.fulfill()
                sleep(3600*5)
                Swift.fatalError(message)
            }

            // act, perform on separate thead because a call to function runs forever
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: testCase)

            waitForExpectations(timeout: noReturnFailureWaitTime) { _ in

                defer {
                    // clean up
                    cleanUp()
                }

                guard let assertionMessage = assertionMessage else {
                    XCTFail(functionName + " is expected to be called.", file: file, line: line)
                    return
                }

                if let expectedMessage = expectedMessage {
                    // assert only if not nil
                    XCTAssertEqual(assertionMessage, expectedMessage, functionName + " called with incorrect message.", file: file, line: line)
                }
            }
    }
}
// swiftlint:enable line_length
