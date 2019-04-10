//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct BarColumnValue: Hashable {
    var id: String
    var value: Int
    var color: CGColor?
}

final class BarColumnValueLayer: CALayer {
    let value: BarColumnValue
    var isEnabled: Bool = true

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

extension BarColumnValue {
    static var empty: BarColumnValue {
        return BarColumnValue(id: "", value: 0, color: nil)
    }
}
