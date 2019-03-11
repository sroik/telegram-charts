//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

public func assertWrapper(
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
