//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarColumnLayer: Layer {
    init(values: [StackedColumnValue]) {
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

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder.cgColor
    }

    func enable(values: Set<String>) {
        self.values.enumerated().forEach { index, value in
            self.values[index].isEnabled = values.contains(value.id)
        }
    }

    func set(range: Range<Int>, maxRange: Range<Int>, animated: Bool) {
        self.range = range
        self.maxRange = maxRange
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        guard !bounds.isEmpty, !range.isEmpty, !maxRange.isEmpty else {
            return
        }

        let scale = CGFloat(maxRange.size) / CGFloat(range.size)
        let frames = StackedColumnValue.barFrames(
            of: values,
            in: bounds,
            range: range,
            minHeight: scale
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
    private var values: [StackedColumnValue]
    private var range: Range<Int> = .zero
    private var maxRange: Range<Int> = .zero
}

extension CALayer {
    convenience init(value: StackedColumnValue) {
        self.init()
        isOpaque = true
        backgroundColor = value.color
        drawsAsynchronously = true
        disableActions()
    }
}
