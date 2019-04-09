//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class LineChartView: ViewportView, ChartViewType {
    let chart: Chart
    let layers: [LineColumnLayer]

    var selectedIndex: Int? {
        get {
            return layers.first?.selectedIndex
        }
        set {
            select(index: newValue)
        }
    }

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.chart = chart
        self.layers = chart.drawableColumns.map { LineColumnLayer(column: $0) }
        super.init(viewport: viewport)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptRange(animated: false)
    }

    override func adaptViewport() {
        super.adaptViewport()
        layers.forEach { layer in
            layer.frame = contentView.bounds
        }
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        adaptRange(animated: animated)

        layers.forEach { layer in
            layer.set(
                value: columns.contains(layer.column) ? 1 : 0,
                for: .opacity,
                animated: animated
            )
        }
    }

    func set(lineWidth: CGFloat) {
        layers.forEach { layer in
            layer.lineWidth = lineWidth
        }
    }

    func select(index: Int?) {
        layers.forEach { layer in
            layer.selectedIndex = index
        }
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)

        layers.forEach { layer in
            layer.set(range: range, animated: animated)
        }
    }

    private func setup() {
        layers.forEach(contentView.layer.addSublayer)
        enable(columns: chart.drawableColumns, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
}
