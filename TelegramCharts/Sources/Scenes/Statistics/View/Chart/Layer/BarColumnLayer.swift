//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarColumnLayer: Layer {
    init(values: [BarColumnValue]) {
        self.values = values
        self.layers = values.map(CALayer.init(value:))
        super.init()
        setup()
    }

    override init(layer: Any) {
        self.layers = []
        self.values = []
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

    func enable(values: Set<String>) {
        self.values.enumerated().forEach { index, value in
            self.values[index].isEnabled = values.contains(value.id)
        }
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

        let frames = BarColumnValue.frames(
            of: values,
            in: bounds,
            range: range,
            minHeight: 1.0
        )

        layers.enumerated().forEach { index, layer in
            let frame = (frames[safe: index] ?? .zero).rounded()
            layer.set(frame: frame, animated: animated)
        }
    }

    private func setup() {
        isOpaque = true
        layers.forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private let layers: [CALayer]
    private var values: [BarColumnValue]
    private var range: Range<Int> = .zero
}

extension CALayer {
    convenience init(value: BarColumnValue) {
        self.init()
        isOpaque = true
        backgroundColor = value.color
        drawsAsynchronously = true
        disableActions()
    }
}
