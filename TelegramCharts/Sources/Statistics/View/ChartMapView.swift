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
        let verticalRange = chart.drawableColumns.range
        chart.drawableColumns.forEach { column in
            let columnLayer = ColumnLayer(column: column)
            columnLayer.viewport = verticalRange
            layer.addSublayer(columnLayer)
            columnLayer.frame = bounds
            columnLayers.append(columnLayer)
        }
    }

    #warning("remove")
    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.background.withAlphaComponent(0.5)
    }

    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart
}
