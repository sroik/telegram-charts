//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartLayer: Layer {
    init(chart: Chart?) {
        self.chart = chart
        super.init()
        setup()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(chart: nil)
    }

    override init(layer: Any) {
        chart = nil
        super.init(layer: layer)
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        columnLayers.forEach {
            $0.frame = bounds
        }
    }

    func redraw() {
        columnLayers.forEach {
            $0.redraw()
        }
    }

    func select(index: Int?) {
        columnLayers.forEach {
            $0.selectedIndex = index
        }
    }

    func set(lineWidth: CGFloat) {
        columnLayers.forEach {
            $0.lineWidth = lineWidth
        }
    }

    func set(pointsThreshold: CGFloat, animated: Bool = false) {
        columnLayers.forEach {
            $0.set(pointsThreshold: pointsThreshold, animated: animated)
        }
    }

    func set(range: Range<Int>, animated: Bool = false) {
        self.range = range
        columnLayers.forEach {
            $0.set(range: range, animated: animated)
        }
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        self.enabledColumns = enabledColumns
        columnLayers.forEach {
            update(layer: $0, animated: animated)
        }
    }

    private func update(layer: ColumnLayer, animated: Bool) {
        layer.set(
            value: enabledColumns.contains(layer.column) ? 1 : 0,
            for: .opacity,
            animated: animated
        )
    }

    private func setup() {
        guard let chart = chart else {
            return
        }

        chart.drawableColumns.forEach { column in
            let layer = ColumnLayer(column: column)
            layer.frame = bounds
            columnLayers.append(layer)
            addSublayer(layer)
        }

        set(enabledColumns: Set(chart.drawableColumns))
        set(range: chart.drawableColumns.range)
    }

    private(set) var range: Range<Int> = .zero
    private(set) var enabledColumns: Set<Column> = []
    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart?
}
