//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapViewDelegate: AnyObject {}

final class ChartMapView: View {
    weak var delegate: ChartMapViewDelegate?

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        columnLayers.forEach { layer in
            layer.frame = bounds
        }
    }

    private func setup() {
        let viewport = viewportRange()
        chart.drawableColumns.forEach { column in
            let columnLayer = ColumnLayer(column: column)
            columnLayer.viewportRange = viewport
            layer.addSublayer(columnLayer)
            columnLayer.frame = bounds
            columnLayers.append(columnLayer)
        }
    }

    private func viewportRange() -> Range<Int> {
        return chart.drawableColumns.reduce(Range<Int>.zero) { range, column in
            range.union(with: column.range)
        }
    }

    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart
}
