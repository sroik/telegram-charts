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

    func stackedValue() -> Int {
        return column.stackedValue()
    }

    func enable(values: Set<String>) {
        column.enable(ids: values)
    }

    func set(maxValue: Int, minHeight: CGFloat, animated: Bool) {
        self.maxValue = maxValue
        self.minHeight = minHeight
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        guard !bounds.isEmpty, maxValue > 0 else {
            return
        }

        let frames = column.barFrames(
            in: bounds,
            maxValue: maxValue,
            minHeight: minHeight
        )

        layers.enumerated().forEach { index, layer in
            let frame = (frames[safe: index] ?? .zero).rounded()
            layer.spring(to: frame, animated: animated)
        }
    }

    private func setup() {
        isOpaque = true
        layers.reversed().forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private let layers: [CALayer]
    private var column: StackedColumn
    private var maxValue: Int = 0
    private var minHeight: CGFloat = 0
}

private extension CALayer {
    convenience init(value: StackedColumnValue) {
        self.init()
        isOpaque = true
        backgroundColor = value.color
        disableActions()
    }
}
