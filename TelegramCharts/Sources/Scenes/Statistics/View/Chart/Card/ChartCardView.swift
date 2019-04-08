//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartCardView: CardView {
    var index: Int = 0 {
        didSet {
            update()
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.titleCell = ChartCardViewCell()
        self.cells = chart.drawableColumns.map { ChartCardViewCell(id: $0.id) }
        super.init(items: [titleCell] + cells)
    }

    private func update() {
        titleCell.summary = date?.string(format: "E, d MMM yyyy")

        chart.drawableColumns.forEach { column in
            guard let cell = self.cell(withId: column.id) else {
                return
            }

            cell.title = column.name
            cell.valueColor = column.uiColor
            cell.value = column.values[safe: index].flatMap { String($0) }
        }
    }

    private func cell(withId id: String) -> ChartCardViewCell? {
        return cells.first { $0.id == id }
    }

    private var date: Date? {
        return timestamp.flatMap(Date.init(timestamp:))
    }

    private var timestamp: Timestamp? {
        return chart.timestamps[safe: index]
    }

    private let titleCell: ChartCardViewCell
    private let cells: [ChartCardViewCell]
    private let chart: Chart
}
