//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class Channel<Value> {
    typealias ObservationBlock = (Value) -> Void

    init() {}

    func send(_ value: Value) {
        synchronized(self) {
            observers.values.forEach { $0.notify(with: value) }
        }
    }

    func subscribe(
        on queue: DispatchQueue? = nil,
        with callback: @escaping ObservationBlock
    ) -> DeinitToken {
        let key = UUID().uuidString

        synchronized(self) {
            observers[key] = Observer(callback: callback, queue: queue)
        }

        return DeinitToken { [weak self] in
            guard let self = self else {
                return
            }

            synchronized(self) {
                self.observers.removeValue(forKey: key)
            }
        }
    }

    private var observers: [String: Observer] = [:]
}

private extension Channel {
    final class Observer {
        let callback: ObservationBlock
        let queue: DispatchQueue?

        init(callback: @escaping ObservationBlock, queue: DispatchQueue?) {
            self.callback = callback
            self.queue = queue
        }

        func notify(with value: Value) {
            guard let queue = queue else {
                callback(value)
                return
            }

            queue.async { [weak self] in
                self?.callback(value)
            }
        }
    }
}
