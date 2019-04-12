//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartCardView: CardView {
    let chart: Chart
    let titleCell: ChartCardViewCell
    let cells: [ChartCardViewCell]

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
        enabledColumnsIds = Set(columns.map { $0.id })
        update(animated: animated)
    }

    func update(animated: Bool) {
        chart.drawableColumns.forEach { column in
            if let cell = self.cell(withId: column.id) {
                update(cell: cell, with: column)
            }
        }

        titleCell.icon = titleIcon
        titleCell.summary = title
        layout(animated: animated)
    }

    func update(cell: ChartCardViewCell, with column: Column) {
        cell.isHidden = !enabledColumnsIds.contains(column.id)
        cell.title = column.name
        cell.valueColor = column.uiColor
        cell.value = String(value: column.values[safe: selectedIndex] ?? 0)
    }

    func cell(withId id: String) -> ChartCardViewCell? {
        return cells.first { $0.id == id }
    }

    private func setup() {
        enable(columns: chart.drawableColumns)
    }

    private var titleIcon: UIImage? {
        return chart.expandable ? Image.rightArrow : nil
    }

    private var title: String? {
        let format = chart.expandable ? "E, d MMM yyyy" : "hh:mm"
        return selectedDate.string(format: format)
    }

    private var selectedDate: Date {
        let timestamp = chart.timestamps[safe: selectedIndex] ?? 0
        return Date(timestamp: timestamp)
    }

    private(set) var enabledColumnsIds: Set<String> = []
}
