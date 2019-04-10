//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func after(_ delay: Double, execute block: @escaping () -> Void) {
        let deadline = DispatchTime.now() + delay
        asyncAfter(deadline: deadline, execute: block)
    }
}

func after(_ delay: TimeInterval, execute block: @escaping () -> Void) {
    DispatchQueue.main.after(delay, execute: block)
}
