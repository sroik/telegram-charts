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
        layers.forEach { $0.frame = bounds }
        draw(animated: false)
    }

    func set(column: StackedColumn, animated: Bool) {
        self.column = column
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        guard !bounds.isEmpty else {
            return
        }

        zip(layers, column.pieSlices()).forEach { layer, slice in
            let path = CGMutablePath()
            path.move(to: bounds.center)
            path.addArc(
                center: bounds.center,
                radius: radius,
                startAngle: slice.min,
                endAngle: slice.max,
                clockwise: false
            )
            path.closeSubpath()
            let bezier = UIBezierPath(cgPath: path)
            layer.path = path
        }
    }

    private func setup() {
        isOpaque = true
        layers.forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private var radius: CGFloat {
        return bounds.minSide / 2
    }

    private var column: StackedColumn
    private let layers: [CAShapeLayer]
}

private extension CAShapeLayer {
    static func pieSlice(value: StackedColumnValue) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = value.color
        layer.disableActions()
        return layer
    }
}
