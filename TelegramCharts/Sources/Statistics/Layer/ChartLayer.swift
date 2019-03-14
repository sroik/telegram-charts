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

    var lineWidth: CGFloat = 1.0 {
        didSet {
            columnLayers.forEach { $0.lineWidth = lineWidth }
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
            layer.lineWidth = lineWidth
            columnLayers.append(layer)
            addSublayer(layer)
        }

        updateLayers()
    }

    private func updateLayers() {
        layersRange = Array(enabledColumns).range
        columnLayers.forEach { update(layer: $0) }
    }

    private func update(layer: ColumnLayer) {
        guard let column = layer.column else {
            return
        }

        let opacity = enabledColumns.contains(column) ? 1 : 0
        layer.set(value: opacity, for: .opacity, animated: true)
        layer.range = layersRange
    }

    private var layersRange: Range<Int> = .zero
    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart?
}
