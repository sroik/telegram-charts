//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class StackedBarChartView: ViewportView, ChartViewType {
    let chart: Chart
    let layout: GridLayout
    let layers: [BarColumnLayer]

    var selectedIndex: Int? {
        didSet {
            #warning("select")
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.layers = BarColumnLayer.layers(with: chart)
        self.layout = GridLayout(itemsNumber: layers.count)
        super.init()
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptRange(animated: false)
    }

    override func adaptViewportSize() {
        super.adaptViewportSize()
        layoutLayers()
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [Column], animated: Bool) {
        let columnsIds = Set(columns.map { $0.id })
        enabledColumns = columns

        layers.forEach { layer in
            layer.enable(values: columnsIds, animated: animated)
        }

        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        layers.forEach { layer in
            layer.set(range: range, animated: animated)
        }
    }

    func layoutLayers() {
        layers.enumerated().forEach { index, layer in
            layer.frame = layout.itemFrame(at: index, in: contentView.bounds)
        }
    }

    private func setup() {
        layers.forEach(contentView.layer.addSublayer)
        enable(columns: chart.drawableColumns, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
}

private extension BarColumnLayer {
    static func layers(with chart: Chart) -> [BarColumnLayer] {
        return chart.timestamps.indices
            .lazy
            .map { BarColumnValue.values(of: chart, at: $0) }
            .map { BarColumnLayer(values: $0) }
    }
}

private extension BarColumnValue {
    static func values(of chart: Chart, at index: Index) -> [BarColumnValue] {
        return chart.drawableColumns.map { column in
            BarColumnValue(
                id: column.id,
                value: column.values[safe: index] ?? 0,
                color: column.cgColor
            )
        }
    }
}
