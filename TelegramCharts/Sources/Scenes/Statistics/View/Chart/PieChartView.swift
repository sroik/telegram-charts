//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class PieChartView: View, ChartViewType {
    let chart: Chart

    var selectedIndex: Int? {
        didSet {}
    }

    var viewport: Viewport {
        didSet {
            adaptViewport()
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.viewport = .zeroToOne
        super.init(frame: .zero)
        setup()
    }

    func adaptViewport() {}

    func enable(columns: [String], animated: Bool) {
        enabledColumns = chart.columns(with: columns)
    }

    private func setup() {
        backgroundColor = .yellow
    }

    private var enabledColumns: [Column] = []
}
