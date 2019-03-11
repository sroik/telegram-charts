//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum OptionalTypeError: Error {
    case unexpectedNil
}

extension Optional {
    func get() throws -> Wrapped {
        return try or(throw: OptionalTypeError.unexpectedNil)
    }

    /** If it's not nil, returns the unwrapped value. Otherwise throws `exception' */
    func or(throw exception: Error) throws -> Wrapped {
        switch self {
        case let .some(unwrapped): return unwrapped
        case .none: throw exception
        }
    }

    func apply(_ transform: (Wrapped) throws -> Void) rethrows {
        guard case let .some(value) = self else {
            return
        }

        try transform(value)
    }
}
