//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartView: View {
    let chart: Chart

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        columnLayers.forEach {
            $0.frame = bounds
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

    func set(pointsThreshold: CGFloat, animated: Bool = false) {
        columnLayers.forEach {
            $0.set(pointsThreshold: pointsThreshold, animated: animated)
        }
    }

    func update(layer: LineColumnLayer, animated: Bool) {
        layer.set(
            value: enabledColumns.contains(layer.column) ? 1 : 0,
            for: .opacity,
            animated: animated
        )
    }

    private func setup() {
        chart.drawableColumns.forEach { column in
            let layer = LineColumnLayer(column: column)
            columnLayers.append(layer)
            self.layer.addSublayer(layer)
        }

        set(enabledColumns: Set(chart.drawableColumns))
        set(range: chart.drawableColumns.range)
    }

    private(set) var range: Range<Int> = .zero
    private(set) var enabledColumns: Set<Column> = []
    private(set) var columnLayers: [LineColumnLayer] = []
}
