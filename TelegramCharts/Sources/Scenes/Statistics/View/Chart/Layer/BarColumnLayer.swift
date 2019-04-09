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
        setup()
    }

    override init(layer: Any) {
        values = []
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(values: [])
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
    }

    func set(range: Range<Int>, animated: Bool) {}

    private func setup() {
        backgroundColor = UIColor.green.cgColor
    }
}

extension BarColumnValue {
    static var empty: BarColumnValue {
        return BarColumnValue(id: "", value: 0, color: nil)
    }
}
