//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieChartView: View {
    let chart: Chart

    var viewport: Viewport = .zeroToOne {
        didSet {
            update(animated: true)
        }
    }

    var selectedColumn: String? {
        get { return chartLayer.selectedValue }
        set { select(column: newValue, animated: true) }
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

    func column(at point: CGPoint) -> String? {
        return enabledColumns.map { $0.id }.first {
            visualPath(of: $0).contains(point)
        }
    }

    func visualPath(of column: String) -> CGPath {
        return chartLayer.visualPath(of: column)
    }

    func select(column: String?, animated: Bool) {
        chartLayer.select(value: column, animated: animated)
    }

    func selectedColumnValue() -> StackedColumnValue? {
        return selectedColumn.flatMap { id in
            stackedColumn().value(with: id)
        }
    }

    func stackedColumn() -> StackedColumn {
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
