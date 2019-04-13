//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class RangeChartGridView: ViewportView, ChartViewportable {
    let animator = ShiftAnimator()
    let cells: [ChartGridViewCell]
    let layout: GridLayout
    let chart: Chart

    init(chart: Chart, layout: GridLayout) {
        self.chart = chart
        self.layout = layout
        self.cells = ChartGridViewCell.cells(count: layout.itemsNumber)
        super.init(autolayouts: false)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        layoutCells()
        adaptRange(animated: false)
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [String], animated: Bool) {
        enabledColumns = chart.columns(with: columns)
        adaptRange(animated: animated)
    }

    func adaptedRange() -> Range<Int> {
        return chart.adjustedRange(of: enabledColumns, in: viewport)
    }

    func adaptRange(animated: Bool) {
        range = adaptedRange()
        cells.enumerated().forEach { index, cell in
            let value = self.value(at: index, in: range) ?? 0
            let scale = CGFloat(value) / CGFloat(cell.state.leftValue ?? 0)

            animator.animate(
                view: cell,
                using: { $0.state.leftValue = value },
                scale: scale,
                animated: animated
            )
        }
    }

    func value(at index: Int, in range: Range<Int>?) -> Int? {
        let maxY = layout.itemFrame(at: index, in: bounds).maxY
        let position = 1 - (maxY / bounds.height)
        return range?.value(at: position)
    }

    func layoutCells() {
        cells.enumerated().forEach { index, cell in
            cell.frame = layout.itemFrame(at: index, in: bounds)
        }
    }

    func setup() {
        isUserInteractionEnabled = false
        clipsToBounds = true
        displayLink.fps = 2
        cells.forEach(addSubview)

        themeUp()
        enable(columns: chart.drawableColumns.ids, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
    private(set) var range: Range<Int> = .zero
}

extension ChartGridViewCell {
    static func cells(count: Int) -> [ChartGridViewCell] {
        return (0 ..< count).map { index in
            var state = ChartGridViewCellState()
            state.lineWidth = index < count - 1 ? .pixel : 0
            return ChartGridViewCell(state: state)
        }
    }
}
