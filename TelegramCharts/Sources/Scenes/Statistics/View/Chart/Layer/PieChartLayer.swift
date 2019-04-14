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
        self.layers = column.values.map(PieSliceLayer.init(value:))
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

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        layers.forEach { layer in
            layer.frame = bounds
        }
    }

    func select(value: String?, animated: Bool) {
        selectedValue = value
        layers.forEach { layer in
            layer.isSelected = layer.id == value
            layer.draw(animated: animated)
        }
    }

    func visualPath(of valueId: String) -> CGPath {
        return layer(with: valueId)?.visualPath ?? .empty
    }

    func set(column: StackedColumn, animated: Bool) {
        self.column = column
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        let percents = column.roundedPercents()
        let slices = column.pieSlices()

        layers.enumerated().forEach { index, layer in
            layer.set(
                percent: percents[safe: index] ?? 0,
                slice: slices[safe: index] ?? .zero,
                animated: animated
            )
        }
    }

    private func layer(with id: String) -> PieSliceLayer? {
        return layers.first { $0.id == id }
    }

    private func setup() {
        isOpaque = true
        layers.forEach(addSublayer)
        disableActions()
        themeUp()
    }

    private(set) var selectedValue: String?
    private var column: StackedColumn
    private let layers: [PieSliceLayer]
}
