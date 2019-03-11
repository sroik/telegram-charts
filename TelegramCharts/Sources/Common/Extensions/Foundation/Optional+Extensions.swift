//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

public enum OptionalTypeError: Error {
    case unexpectedNil
}

public extension Optional {
    
    public func get() throws -> Wrapped {
        return try or(throw: OptionalTypeError.unexpectedNil)
    }
    
    /** If it's not nil, returns the unwrapped value. Otherwise throws `exception' */
    public func or(throw exception: Error) throws -> Wrapped {
        switch self {
        case let .some(unwrapped): return unwrapped
        case .none: throw exception
        }
    }
    
    public func apply(_ transform: (Wrapped) throws -> Void) rethrows {
        guard case let .some(value) = self else {
            return
        }
        
        try transform(value)
    }
}
