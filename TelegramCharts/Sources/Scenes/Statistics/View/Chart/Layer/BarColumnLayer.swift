//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarColumnLayer: Layer {
    let layers: [BarColumnValueLayer]

    init(values: [BarColumnValue]) {
        self.layers = values.map(BarColumnValueLayer.init(value:))
        super.init()
        setup()
    }

    override init(layer: Any) {
        self.layers = []
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(values: [])
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        draw(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder.cgColor
    }

    func enable(values: Set<String>, animated: Bool) {
        layers.forEach { layer in
            layer.isEnabled = values.contains(layer.value.id)
        }

        draw(animated: animated)
    }

    func set(range: Range<Int>, animated: Bool) {
        guard self.range != range else {
            return
        }

        self.range = range
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        guard !bounds.isEmpty, !range.isEmpty else {
            return
        }

        var maxY = bounds.height
        let ratio = CGFloat(stackedValue) / CGFloat(range.size)

        for layer in layers {
//            layer.frame = CGRect(
//                maxY: bounds.height,
//                width: bounds.width,
//                height: bounds.height * ratio
//            )
        }
    }

    private func setup() {
        isOpaque = true
        layers.reversed().forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private var stackedValue: Int {
        return layers
            .filter { $0.isEnabled }
            .reduce(0) { $0 + $1.value.value }
    }

    private var range: Range<Int> = .zero
}
