//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartView: ViewportView {
    let chart: Chart

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.chart = chart
        super.init(viewport: viewport)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptRange(animated: false)
    }

    override func adaptViewport() {
        super.adaptViewport()
        columnLayers.forEach {
            $0.frame = contentView.bounds
        }
    }

    override func display() {
        super.display()
        #warning("try to do it from parent")
        adaptRange(animated: true)
    }

    func select(index: Int?) {
        columnLayers.forEach { layer in
            layer.selectedIndex = index
        }
    }

    func adaptRange(animated: Bool) {
        let range = Array(enabledColumns).range(in: viewport)
        columnLayers.forEach { layer in
            layer.set(range: range, animated: animated)
        }
    }

    func set(enabledColumns columns: Set<Column>, animated: Bool) {
        enabledColumns = columns
        adaptRange(animated: animated)

        columnLayers.forEach { layer in
            layer.set(
                value: columns.contains(layer.column) ? 1 : 0,
                for: .opacity,
                animated: animated
            )
        }
    }

    func set(lineWidth: CGFloat) {
        columnLayers.forEach { layer in
            layer.lineWidth = lineWidth
        }
    }

    private func setup() {
        chart.drawableColumns.forEach { column in
            let layer = LineColumnLayer(column: column)
            columnLayers.append(layer)
            contentView.layer.addSublayer(layer)
        }

        set(enabledColumns: Set(chart.drawableColumns), animated: false)
    }

    private var range: Range<Int> = .zero
    private var enabledColumns: Set<Column> = []
    private var columnLayers: [LineColumnLayer] = []
}
