//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class RangeChartGridView: ViewportView, ChartViewportable {
    let animator = ShiftAnimator()
    let cells: [ChartGridViewCell]
    let layout: GridLayout
    let chart: Chart

    init(chart: Chart, layout: GridLayout = .values, viewport: Viewport = .zeroToOne) {
        self.chart = chart
        self.layout = layout
        self.cells = ChartGridViewCell.cells(count: layout.itemsNumber)
        super.init(viewport: viewport, autolayouts: false)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptRange(animated: false)
        layoutCells()
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        let rangeMidScale = CGFloat(self.range.mid) / CGFloat(range.mid)
        self.range = range

        cells.enumerated().forEach { index, cell in
            animator.animate(
                view: cell,
                using: { self.update(cell: $0, at: index) },
                scale: rangeMidScale,
                animated: animated
            )
        }
    }

    func update(cell: ChartGridViewCell, at index: Index) {
        cell.state.leftValue = value(at: index, in: range)
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

    private func setup() {
        isUserInteractionEnabled = false
        clipsToBounds = true
        displayLink.fps = 2
        cells.forEach(addSubview)

        themeUp()
        enable(columns: chart.drawableColumns, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
    private(set) var range: Range<Int> = .zero
}

extension ChartGridViewCell {
    static func cells(count: Int) -> [ChartGridViewCell] {
        return (0 ..< count).map { index in
            var state = ChartGridViewCellState()
            state.hasLine = index < count - 1
            return ChartGridViewCell(state: state)
        }
    }
}
