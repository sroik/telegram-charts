//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartGridView: View {
    init(layout: ChartGridLayout = .values, range: Range<Int>) {
        self.range = range
        self.layout = layout
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        rebuildCells()
    }

    func set(range: Range<Int>, animated: Bool) {
        guard self.range != range else {
            return
        }

        self.range = range
        cells.enumerated().forEach { index, cell in
            let value = cellValue(at: index)
            let scale = CGFloat(cell.state.leftValue ?? value) / CGFloat(value)

            animator.update(
                cell,
                using: { $0.state.leftValue = value },
                scale: scale,
                animated: animated
            )
        }
    }

    private func rebuildCells() {
        guard !bounds.isEmpty else {
            return
        }

        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()

        (0 ..< cellsNumber).forEach { index in
            var state = ChartGridViewCellState()
            state.leftValue = cellValue(at: index)
            state.hasLine = index < cellsNumber - 1

            let cell = ChartGridViewCell(state: state)
            cell.frame = layout.itemFrame(at: index, in: bounds)
            cell.theme = theme
            cells.append(cell)
            addSubview(cell)
        }
    }

    private func cellValue(at index: Int) -> Int {
        let maxY = layout.itemFrame(at: index, in: bounds).maxY
        let position = 1 - (maxY / bounds.height)
        return range.value(at: position)
    }

    private func setup() {
        isUserInteractionEnabled = false
        clipsToBounds = true
    }

    private var cellsNumber: Int {
        return layout.itemsNumber
    }

    private let animator = ChartGridAnimator()
    private let layout: ChartGridLayout
    private var cells: [ChartGridViewCell] = []
    private var range: Range<Int>
}
