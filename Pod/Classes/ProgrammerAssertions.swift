//
//  ProgrammerAssertions.swift
//  Pods
//
//  Created by Steven Chan on 4/1/16.
//
//

import Foundation

@noreturn public func fatalError(
    @autoclosure message: () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    Assertions.fatalErrorClosure(message(), file, line)
    runForever()
}

// Stores custom assertions closures,
// by default it points to Swift functions. But test target can override them.
public class Assertions {
    public static var fatalErrorClosure =
        swiftFatalErrorClosure

    public static let swiftFatalErrorClosure = {
        Swift.fatalError($0, file: $1, line: $2)
    }
}

// This is a `noreturn` function that runs forever and doesn't return.
// Used by assertions with `@noreturn`.
@noreturn private func runForever() {
    repeat {
        NSRunLoop.currentRunLoop().run()
    } while (true)
}
