//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartGridView: View {
    init(layout: ChartGridLayout = .default, range: Range<Int>) {
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

        let rangeScale = CGFloat(self.range.size) / CGFloat(range.size)
        self.range = range
        cells.enumerated().forEach { index, cell in
            animator.update(
                cell,
                with: cellValue(at: index),
                scale: rangeScale,
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
            let cell = ChartGridViewCell(value: cellValue(at: index))
            cell.isLineHidden = index == cellsNumber - 1
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
        return layout.itemsNumber(in: bounds)
    }

    private let animator = ChartGridAnimator()
    private let layout: ChartGridLayout
    private var cells: [ChartGridViewCell] = []
    private var range: Range<Int>
}
