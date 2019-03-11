//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

@discardableResult
public func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}

func assertWrapper(
    _ condition: @autoclosure () -> Bool,
    _ domain: @autoclosure () -> String = String(),
    _ message: @autoclosure () -> String? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard !condition() else {
        return
    }

    guard !Environment.isTests else {
        print("assertion failed: ", domain())
        return
    }

    assertionFailure(domain(), file: file, line: line)
}

func assertionFailureWrapper(
    _ domain: @autoclosure () -> String = String(),
    _ message: @autoclosure () -> String? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    assertWrapper(
        false,
        domain,
        message,
        file: file,
        line: line
    )
}
