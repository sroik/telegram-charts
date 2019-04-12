//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ColumnsListViewDelegate: AnyObject {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column])
    func columnsViewDidLongPress(_ view: ColumnsListView)
}

final class ColumnsListView: View {
    weak var delegate: ColumnsListViewDelegate?

    var enabledColumns: [Column] {
        return cells.filter { $0.isSelected }.map { $0.column }
    }

    convenience init(chart: Chart, layout: ShelfLayout = .default, sounds: SoundService) {
        self.init(columns: chart.drawableColumns, layout: layout, sounds: sounds)
    }

    init(columns: [Column], layout: ShelfLayout = .default, sounds: SoundService) {
        self.sounds = sounds
        self.columns = columns
        self.layout = layout
        self.cells = columns.map(ColumnsListViewCell.init(column:))
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        updateFrames()
    }

    func enable(columns: [Column], animated: Bool) {
        let ids = Set(columns.map { $0.id })
        cells.forEach { cell in
            if cell.isSelected != ids.contains(cell.column.id) {
                cell.toggle(animated: animated)
            }
        }
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

        let press = UILongPressGestureRecognizer(target: self, action: #selector(onPress))
        press.minimumPressDuration = 0.25
        addGestureRecognizer(press)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    private func canToggle(cell: ColumnsListViewCell) -> Bool {
        return !cell.isSelected || enabledColumns.count > 1
    }

    @objc private func onPress(_ recognizer: UILongPressGestureRecognizer) {
        delegate?.columnsViewDidLongPress(self)
    }

    @objc private func onTap(_ recognizer: UIGestureRecognizer) {
        let point = recognizer.location(in: self)
        let isNotInCell = cells.allSatisfy { !$0.frame.contains(point) }
        if isNotInCell {
            delegate?.columnsViewDidLongPress(self)
        }
    }

    @objc private func cellPressed(_ cell: ColumnsListViewCell) {
        guard canToggle(cell: cell) else {
            sounds.play(.haptic(event: .notification(.error)))
            cell.layer.shake()
            return
        }

        sounds.play(.haptic(event: .selection))
        cell.toggle()
        delegate?.columnsView(self, didEnable: enabledColumns)
    }

    private let cells: [ColumnsListViewCell]
    private let layout: ShelfLayout
    private let sounds: SoundService
    private let columns: [Column]
}
