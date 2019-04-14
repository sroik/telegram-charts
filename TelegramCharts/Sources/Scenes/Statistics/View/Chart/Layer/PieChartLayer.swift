//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieChartLayer: Layer {
    convenience init(chart: Chart) {
        let column = StackedColumn(columns: chart.drawableColumns, at: 0)
        self.init(column: column)
    }

    init(column: StackedColumn) {
        self.column = column
        self.layers = column.values.map(CAShapeLayer.pieSlice)
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

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        layoutLayers()
        draw(animated: false)
    }

    func set(column: StackedColumn, animated: Bool) {
        self.column = column
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        zip(layers, column.pieSlices()).forEach { layer, slice in
            layer.spring(
                to: slice.degreeInflated(),
                animated: animated
            )
        }
    }

    private func layoutLayers() {
        layers.forEach { layer in
            layer.frame = bounds
            layer.path = piePath
            layer.lineWidth = radius * 2
        }
    }

    private func setup() {
        isOpaque = true
        layers.forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private var piePath: CGPath {
        return CGPath.circle(
            center: bounds.center,
            radius: radius
        )
    }

    private var radius: CGFloat {
        return bounds.minSide / 4
    }

    private var column: StackedColumn
    private let layers: [CAShapeLayer]
}

private extension CAShapeLayer {
    static func pieSlice(value: StackedColumnValue) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = value.color
        layer.fillColor = nil
        layer.disableActions()
        return layer
    }
}

private extension Range where T == CGFloat {
    func degreeInflated() -> Range {
        guard abs(max - min) > .ulpOfOne else {
            return self
        }

        let degree: CGFloat = 1 / 360
        return Range(min: min - degree, max: max + degree)
    }
}

private extension StackedColumn {
    func pieSlices() -> [Slice] {
        return slices(height: 1)
    }
}
