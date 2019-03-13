//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartLayer: CALayer {
    var enabledColumns: Set<Column> = [] {
        didSet {
            updateLayers()
        }
    }

    init(chart: Chart?) {
        self.chart = chart
        self.enabledColumns = Set(chart?.drawableColumns ?? [])
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

    override func layoutSublayers() {
        super.layoutSublayers()
        columnLayers.forEach { $0.frame = bounds }
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

        updateLayers()
    }

    private func updateLayers() {
        layersViewport = Array(enabledColumns).range
        columnLayers.forEach { update(layer: $0) }
    }

    private func update(layer: ColumnLayer) {
        guard let column = layer.column else {
            return
        }

        layer.isHidden = !enabledColumns.contains(column)
        layer.viewport = layersViewport
    }

    private var layersViewport: Range<Int> = .zero
    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart?
}
