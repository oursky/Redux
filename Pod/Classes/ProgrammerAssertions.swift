//
//  ProgrammerAssertions.swift
//  Pods
//
//  Created by Steven Chan on 4/1/16.
//
//

import Foundation

public func fatalError(
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Never  {
    Assertions.fatalErrorClosure(message(), file, line)
    runForever()
}

// Stores custom assertions closures,
// by default it points to Swift functions. But test target can override them.
open class Assertions {
    open static var fatalErrorClosure =
        swiftFatalErrorClosure

    open static let swiftFatalErrorClosure = {
        Swift.fatalError($0, file: $1, line: $2)
    }
}

// This is a `noreturn` function that runs forever and doesn't return.
// Used by assertions with `@noreturn`.
private func runForever() -> Never  {
    repeat {
        RunLoop.current.run()
    } while (true)
}
