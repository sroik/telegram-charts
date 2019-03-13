//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartView: View {
    var enabledColumns: Set<Column> {
        didSet {
            chartLayer.enabledColumns = enabledColumns
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.enabledColumns = Set(chart.drawableColumns)
        self.chartLayer = ChartLayer(chart: chart)
        super.init(frame: .screen)
        setup()
    }

    private func setup() {
        scrollView.fill(in: self)
    }

    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
