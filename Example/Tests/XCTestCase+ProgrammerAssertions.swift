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

public extension XCTestCase {
    
    /**
    Expects an `assert` to be called with a false condition.
    If `assert` not called or the assert's condition is true, the test case will fail.
    
    - parameter expectedMessage: The expected message to be asserted to the one passed to the `assert`. If nil, then ignored.
    - parameter file:            The file name that called the method.
    - parameter line:            The line number that called the method.
    - parameter testCase:        The test case to be executed that expected to fire the assertion method.
    */
    public func expectAssert(
        expectedMessage: String? = nil,
        file: StaticString = __FILE__,
        line: UInt = __LINE__,
        testCase: () -> Void
        ) {
            
            expectAssertionReturnFunction("assert", file: file, line: line, function: { (caller) -> () in
                
                Assertions.assertClosure = { condition, message, _, _ in
                    caller(condition, message)
                }
                
                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.assertClosure = Assertions.swiftAssertClosure
            }
    }
    
    /**
    Expects an `assertionFailure` to be called.
    If `assertionFailure` not called, the test case will fail.
    
    - parameter expectedMessage: The expected message to be asserted to the one passed to the `assertionFailure`. If nil, then ignored.
    - parameter file:            The file name that called the method.
    - parameter line:            The line number that called the method.
    - parameter testCase:        The test case to be executed that expected to fire the assertion method.
    */
    public func expectAssertionFailure(
        expectedMessage: String? = nil,
        file: StaticString = __FILE__,
        line: UInt = __LINE__,
        testCase: () -> Void
        ) {
            
            expectAssertionReturnFunction("assertionFailure", file: file, line: line, function: { (caller) -> () in
                
                Assertions.assertionFailureClosure = { message, _, _ in
                    caller(false, message)
                }
                
                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.assertionFailureClosure = Assertions.swiftAssertionFailureClosure
            }
    }
    
    /**
    Expects an `precondition` to be called with a false condition.
    If `precondition` not called or the precondition's condition is true, the test case will fail.
    
    - parameter expectedMessage: The expected message to be asserted to the one passed to the `precondition`. If nil, then ignored.
    - parameter file:            The file name that called the method.
    - parameter line:            The line number that called the method.
    - parameter testCase:        The test case to be executed that expected to fire the assertion method.
    */
    public func expectPrecondition(
        expectedMessage: String? = nil,
        file: StaticString = __FILE__,
        line: UInt = __LINE__,
        testCase: () -> Void
        ) {
            
            expectAssertionReturnFunction("precondition", file: file, line: line, function: { (caller) -> () in
                
                Assertions.preconditionClosure = { condition, message, _, _ in
                    caller(condition, message)
                }
                
                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.preconditionClosure = Assertions.swiftPreconditionClosure
            }
    }
    
    /**
    Expects an `preconditionFailure` to be called.
    If `preconditionFailure` not called, the test case will fail.
    
    - parameter expectedMessage: The expected message to be asserted to the one passed to the `preconditionFailure`. If nil, then ignored.
    - parameter file:            The file name that called the method.
    - parameter line:            The line number that called the method.
    - parameter testCase:        The test case to be executed that expected to fire the assertion method.
    */
    public func expectPreconditionFailure(
        expectedMessage: String? = nil,
        file: StaticString = __FILE__,
        line: UInt = __LINE__,
        testCase: () -> Void
        ) {
            
            expectAssertionNoReturnFunction("preconditionFailure", file: file, line: line, function: { (caller) -> () in
                
                Assertions.preconditionFailureClosure = { message, _, _ in
                    caller(message)
                }
                
                }, expectedMessage: expectedMessage, testCase: testCase) { () -> () in
                    Assertions.preconditionFailureClosure = Assertions.swiftPreconditionFailureClosure
            }
    }
    
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
    
    private func expectAssertionReturnFunction(
        functionName: String,
        file: StaticString,
        line: UInt,
        function: (caller: (Bool, String) -> Void) -> Void,
        expectedMessage: String? = nil,
        testCase: () -> Void,
        cleanUp: () -> ()
        ) {
            
            let expectation = expectationWithDescription(functionName + "-Expectation")
            var assertion: (condition: Bool, message: String)? = nil
            
            function { (condition, message) -> Void in
                assertion = (condition, message)
                expectation.fulfill()
            }
            
            // perform on the same thread since it will return
            testCase()
            
            waitForExpectationsWithTimeout(0) { _ in
                
                defer {
                    // clean up
                    cleanUp()
                }
                
                guard let assertion = assertion else {
                    XCTFail(functionName + " is expected to be called.", file: file.stringValue, line: line)
                    return
                }
                
                XCTAssertFalse(assertion.condition, functionName + " condition expected to be false", file: file.stringValue, line: line)
                
                if let expectedMessage = expectedMessage {
                    // assert only if not nil
                    XCTAssertEqual(assertion.message, expectedMessage, functionName + " called with incorrect message.", file: file.stringValue, line: line)
                }
            }
    }
    
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
