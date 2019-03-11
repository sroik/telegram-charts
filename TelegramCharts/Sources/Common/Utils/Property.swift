//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

/*
 custom lightweight property,
 suitable only for the contest
 */
final class Property<Value> {
    typealias ObservationBlock = (Value) -> Void

    var value: Value {
        didSet {
            synchronized(self) {
                channel.send(value)
            }
        }
    }

    init(value: Value) {
        self.value = value
    }

    func subscribe(
        on queue: DispatchQueue? = nil,
        with callback: @escaping ObservationBlock
    ) -> DeinitToken {
        return channel.subscribe(on: queue, with: callback)
    }

    func bind(
        on queue: DispatchQueue? = nil,
        with callback: @escaping ObservationBlock
    ) -> DeinitToken {
        return synchronized(self) {
            callback(value)
            return subscribe(on: queue, with: callback)
        }
    }

    private let channel = Channel<Value>()
}
