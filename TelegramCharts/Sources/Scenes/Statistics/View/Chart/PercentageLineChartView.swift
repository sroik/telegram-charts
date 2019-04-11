//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class PercentageLineChartView: ViewportView, ChartViewType {
    var selectedIndex: Int?
    let chart: Chart

    init(chart: Chart) {
        self.chart = chart
        super.init()
        setup()
    }

    override func adaptViewportSize() {
        super.adaptViewportSize()
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        /* do smth */
    }

    private func setup() {
        enable(columns: chart.drawableColumns, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
}
