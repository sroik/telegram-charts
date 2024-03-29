//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class PercentageLineChartView: ViewportView, TimelineChartViewType {
    var selectedIndex: Int?
    let chart: Chart

    init(chart: Chart) {
        self.chartLayer = PercentageLineChartLayer(chart: chart)
        self.chart = chart
        super.init()
        setup()
    }

    override func adaptViewportSize() {
        super.adaptViewportSize()
        chartLayer.frame = contentView.bounds
    }

    func enable(columns: [String], animated: Bool) {
        chartLayer.enable(
            values: Set(columns),
            animated: animated
        )
    }

    private func setup() {
        contentView.layer.addSublayer(chartLayer)
        enable(columns: chart.drawableColumns.ids, animated: false)
    }

    private let chartLayer: PercentageLineChartLayer
}
