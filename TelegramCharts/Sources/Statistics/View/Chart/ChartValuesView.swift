//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartValuesView: View {
    init(range: Range<Int>) {
        self.range = range
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        rebuildLabels()
    }

    override func themeUp() {
        super.themeUp()
        cells.forEach { $0.theme = theme }
    }

    func set(range: Range<Int>, animated: Bool = false) {}

    private func setup() {
        isUserInteractionEnabled = false
    }

    private func rebuildLabels() {
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()

        (0 ..< cellsNumber).forEach { index in
            let cell = ChartValuesViewCell()
            cell.theme = theme
            cell.value = index
            cell.frame = cellFrame(at: index)
            cell.isUnderlined = index < cellsNumber - 1
            cells.append(cell)
            addSubview(cell)
        }
    }

    private func cellFrame(at index: Index) -> CGRect {
        return CGRect(
            x: 0,
            y: CGFloat(index) * (cellHeight + spacing),
            width: bounds.width,
            height: cellHeight
        )
    }

    private var spacing: CGFloat {
        let cellsHeight = CGFloat(cellsNumber) * cellHeight
        let freeSpace = bounds.height - cellsHeight
        let spacing = freeSpace / CGFloat(cellsNumber - 1)
        return spacing
    }

    private var cellsNumber: Int {
        /* const 1 means that top cell has no spacing  */
        let freeSpace = bounds.height - cellHeight
        let cells = Int(freeSpace / (minimumSpacing + cellHeight))
        return cells + 1
    }

    private let minimumSpacing: CGFloat = 30
    private let cellHeight: CGFloat = 20
    private var range: Range<Int>
    private(set) var cells: [ChartValuesViewCell] = []
}
