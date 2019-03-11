//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

protocol Token {
    var isCancelled: Bool { get }
    func cancel()
}

class SimpleToken: Token {
    typealias Action = () -> Void

    init(action: @escaping Action = {}) {
        self.action = action
    }

    func cancel() {
        synchronized(self) {
            if isCancelled {
                return
            }

            isCancelled = true
            action()
        }
    }

    private let action: Action
    private(set) var isCancelled: Bool = false
}

class DeinitToken: SimpleToken {
    convenience init(token: Token) {
        self.init {
            token.cancel()
        }
    }

    deinit {
        cancel()
    }
}
