//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarChartView: ViewportView, ChartViewType {
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
        layers.forEach { $0.set(range: range, animated: animated) }
    }

    func layoutLayers() {
        layers.enumerated().forEach { index, layer in
            let rect = contentView.bounds
            layer.frame = layout.itemFrame(at: index, in: rect).rounded()
        }
    }

    private func setup() {
        displayLink.fps = 1
        layers.forEach(contentView.layer.addSublayer)
        enable(columns: chart.drawableColumns, animated: false)
    }

    private var enabledColumns: [Column] = []
}

private extension BarColumnLayer {
    static func layers(with chart: Chart) -> [BarColumnLayer] {
        return chart.timestamps.indices
            .map { BarColumnValue.values(of: chart.drawableColumns, at: $0) }
            .map { BarColumnLayer(values: $0) }
    }
}
