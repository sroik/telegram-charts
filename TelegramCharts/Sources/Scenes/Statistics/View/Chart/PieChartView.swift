//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieChartView: View, ChartViewType {
    let chart: Chart

    var selectedIndex: Int? {
        didSet {}
    }

    var viewport: Viewport = .zeroToOne {
        didSet {
            update(animated: true)
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.chartLayer = PieChartLayer(chart: chart)
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartLayer.frame = bounds
        update(animated: true)
    }

    func enable(columns: [String], animated: Bool) {
        enabledColumns = chart.columns(with: columns)
        update(animated: animated)
    }

    func update(animated: Bool) {
        chartLayer.set(
            column: stackedColumn(),
            animated: animated
        )
    }

    private func stackedColumn() -> StackedColumn {
        var column = StackedColumn(columns: chart.drawableColumns, in: viewport)
        column.enable(ids: Set(enabledColumns.ids))
        return column
    }

    private func setup() {
        layer.addSublayer(chartLayer)
    }

    private var enabledColumns: [Column] = []
    private let chartLayer: PieChartLayer
}
