//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartGridView: ViewportView, ChartViewportable {
    init(chart: Chart, layout: GridLayout = .values, viewport: Viewport = .zeroToOne) {
        self.chart = chart
        self.layout = layout
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
        let range = enabledColumns.range(in: viewport)

        guard self.range != range else {
            return
        }

        let rangeScale = CGFloat(self.range.mid) / CGFloat(range.mid)
        self.range = range

        cells.enumerated().forEach { index, cell in
            animator.animate(
                view: cell,
                using: { self.update(cell: $0, at: index) },
                scale: rangeScale,
                animated: animated
            )
        }
    }

    func update(cell: ChartGridViewCell, at index: Index) {
        cell.state.leftValue = value(at: index, in: range)
    }

    func layoutCells() {
        cells.enumerated().forEach { index, cell in
            cell.frame = layout.itemFrame(at: index, in: bounds)
        }
    }

    func value(at index: Int, in range: Range<Int>) -> Int {
        let maxY = layout.itemFrame(at: index, in: bounds).maxY
        let position = 1 - (maxY / bounds.height)
        return range.value(at: position)
    }

    private func setup() {
        isUserInteractionEnabled = false
        clipsToBounds = true
        displayLink.fps = 2

        (0 ..< layout.itemsNumber).forEach { index in
            var state = ChartGridViewCellState()
            state.hasLine = index < layout.itemsNumber - 1

            let cell = ChartGridViewCell(state: state)
            cell.theme = theme
            cells.append(cell)
            addSubview(cell)
        }

        enable(columns: chart.drawableColumns, animated: false)
    }

    private var range: Range<Int> = .zero
    private var enabledColumns: [Column] = []
    private let animator = ShiftAnimator()
    private var cells: [ChartGridViewCell] = []
    private let layout: GridLayout
    private let chart: Chart
}
