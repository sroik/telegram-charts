//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ColumnsStateViewDelegate: AnyObject {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column])
}

final class ColumnsListView: View {
    weak var delegate: ColumnsStateViewDelegate?

    var enabledColumns: [Column] {
        return cells.filter { $0.isSelected }.map { $0.column }
    }

    init(
        columns: [Column],
        layout: ShelfLayout = .default,
        sounds: SoundService
    ) {
        self.sounds = sounds
        self.columns = columns
        self.layout = layout
        self.cells = columns.map(ColumnsListViewCell.init(column:))
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrames()
    }

    func size(fitting width: CGFloat) -> CGSize {
        return layout.size(of: cells, fitting: width)
    }

    private func updateFrames() {
        let frames = layout.frames(of: cells, fitting: bounds.width)
        cells.enumerated().forEach { index, cell in
            cell.frame = frames[safe: index] ?? .zero
        }
    }

    private func setup() {
        cells.forEach { cell in
            cell.addTarget(self, action: #selector(cellPressed), for: .touchUpInside)
            cell.isSelected = true
            addSubview(cell)
        }
    }

    private func canToggle(cell: ColumnsListViewCell) -> Bool {
        return !cell.isSelected || enabledColumns.count > 1
    }

    @objc private func cellPressed(_ cell: ColumnsListViewCell) {
        guard canToggle(cell: cell) else {
            sounds.play(.errorFeedback)
            cell.layer.shake()
            return
        }

        sounds.play(.selectionFeedback)
        cell.toggle()
        delegate?.columnsView(self, didEnable: enabledColumns)
    }

    private let cells: [ColumnsListViewCell]
    private let layout: ShelfLayout
    private let sounds: SoundService
    private let columns: [Column]
}

extension ColumnsListViewCell: Sizeable {
    var size: CGSize {
        return intrinsicContentSize
    }
}
