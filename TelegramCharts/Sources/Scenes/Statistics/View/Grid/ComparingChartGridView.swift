//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ComparingChartGridView: RangeChartGridView {
    override func adaptRange(animated: Bool) {
        leftRange = leftColumn.flatMap { chart.adjustedRange(of: $0, in: viewport) }
        rightRange = rightColumn.flatMap { chart.adjustedRange(of: $0, in: viewport) }

        cells.enumerated().forEach { index, cell in
            animator.animate(
                view: cell,
                using: { self.update(cell: $0, at: index) },
                animated: animated
            )
        }
    }

    override func update(cell: ChartGridViewCell, at index: Index) {
        var state = cell.state
        state.leftValue = value(at: index, in: leftRange)
        state.rightValue = value(at: index, in: rightRange)
        state.leftColor = leftColumn?.uiColor
        state.rightColor = rightColumn?.uiColor
        cell.state = state
    }

    private var leftColumn: Column? {
        return enabledColumns.first
    }

    private var rightColumn: Column? {
        return enabledColumns.count > 1 ? enabledColumns.last : nil
    }

    private var leftRange: Range<Int>?
    private var rightRange: Range<Int>?
}
