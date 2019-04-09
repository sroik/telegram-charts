//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct BarColumnValue {
    var id: String
    var value: Int
    var color: CGColor?
}

final class BarColumnLayer: Layer {
    let values: [BarColumnValue]

    init(values: [BarColumnValue]) {
        self.values = values
        super.init()
    }

    override init(layer: Any) {
        values = []
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(values: [])
    }

    func set(range: Range<Int>, animated: Bool) {}

    private func setup() {
        borderWidth = 1
    }
}

extension BarColumnValue {
    static var empty: BarColumnValue {
        return BarColumnValue(id: "", value: 0, color: nil)
    }
}
