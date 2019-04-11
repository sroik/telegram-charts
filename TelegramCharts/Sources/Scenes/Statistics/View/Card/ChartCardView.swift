//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartCardView: CardView {
    var selectedIndex: Int = 0 {
        didSet {
            update(animated: true)
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.titleCell = ChartCardViewCell()
        self.cells = chart.drawableColumns.map { ChartCardViewCell(id: $0.id) }
        super.init(items: [titleCell] + cells)
        setup()
    }

    func enable(columns: [Column], animated: Bool = false) {
        enabledColumns = Set(columns.map { $0.id })
        update(animated: animated)
    }

    private func update(animated: Bool) {
        chart.drawableColumns.forEach { column in
            if let cell = self.cell(withId: column.id) {
                update(cell: cell, with: column)
            }
        }

        titleCell.icon = titleIcon
        titleCell.summary = title
        layout(animated: animated)
    }

    private func update(cell: ChartCardViewCell, with column: Column) {
        cell.isHidden = !enabledColumns.contains(column.id)
        cell.title = column.name
        cell.valueColor = column.uiColor
        cell.value = String(value: column.values[safe: selectedIndex] ?? 0)
    }

    private func cell(withId id: String) -> ChartCardViewCell? {
        return cells.first { $0.id == id }
    }

    private func setup() {
        enable(columns: chart.drawableColumns)
    }

    private var titleIcon: UIImage? {
        return chart.expandable ? Image.rightArrow : nil
    }

    private var title: String? {
        let format = chart.expandable ? "E, d MMM yyyy" : "hh : mm"
        return selectedDate.string(format: format)
    }

    private var selectedDate: Date {
        let timestamp = chart.timestamps[safe: selectedIndex] ?? 0
        return Date(timestamp: timestamp)
    }

    private let chart: Chart
    private let titleCell: ChartCardViewCell
    private let cells: [ChartCardViewCell]
    private var enabledColumns: Set<String> = []
}
