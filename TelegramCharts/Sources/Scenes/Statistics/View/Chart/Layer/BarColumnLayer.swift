//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarColumnLayer: Layer {
    init(column: StackedColumn) {
        self.column = column
        self.layers = column.values.map(CALayer.init(value:))
        super.init()
        setup()
    }

    override init(layer: Any) {
        self.layers = []
        self.column = .empty
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(column: .empty)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder.cgColor
    }

    func enable(values: Set<String>) {
        column.enable(ids: values)
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
        let frames = column.barFrames(in: bounds, maxValue: range.max, minHeight: scale)

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
    private var column: StackedColumn
    private var range: Range<Int> = .zero
    private var maxRange: Range<Int> = .zero
}

private extension CALayer {
    convenience init(value: StackedColumnValue) {
        self.init()
        isOpaque = true
        backgroundColor = value.color
        disableActions()
    }
}
