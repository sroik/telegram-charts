//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarColumnValueLayer: CALayer {
    var value: BarColumnValue {
        didSet {
            backgroundColor = value.color
        }
    }

    init(value: BarColumnValue) {
        self.value = value
        super.init()
        setup()
    }

    override init(layer: Any) {
        self.value = .empty
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(value: .empty)
    }

    private func setup() {
        isOpaque = true
        backgroundColor = value.color
        disableActions()
    }
}
