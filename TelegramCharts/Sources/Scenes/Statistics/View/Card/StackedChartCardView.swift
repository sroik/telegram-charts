//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class StackedChartCardView: ChartCardView {
    override init(chart: Chart) {
        summaryCell = ChartCardViewCell(title: "All")
        super.init(chart: chart)
        items.append(summaryCell)
    }

    override func update(animated: Bool) {
        super.update(animated: animated)
        updateSummaryCell()
        updatePercentage()
    }

    private func updatePercentage() {
        guard chart.percentage else {
            return
        }

        let percentages = selectedStackedColumn.percents()
        zip(cells, percentages).forEach { cell, percent in
            cell.summary = String(percent: percent)
        }
    }

    private func updateSummaryCell() {
        guard !chart.percentage else {
            summaryCell.isHidden = true
            return
        }

        let stackedValue = selectedStackedColumn.stackedValue()
        summaryCell.value = String(value: stackedValue)
        summaryCell.isHidden = false
    }

    private var selectedStackedColumn: StackedColumn {
        var column = StackedColumn(columns: chart.drawableColumns, at: selectedIndex)
        column.enable(ids: enabledColumnsIds)
        return column
    }

    private let summaryCell: ChartCardViewCell
}
