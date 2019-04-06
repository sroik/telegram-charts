//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartColumnsStackViewDelegate: AnyObject {
    func columnsView(_ view: ChartColumnsStackView, didChangeEnabledColumns columns: [Column])
}

final class ChartColumnsStackView: View {
    weak var delegate: ChartColumnsStackViewDelegate?

    var enabledColumns: [Column] {
        return cells.filter { $0.isSelected }.map { $0.column }
    }

    init(sounds: SoundService, columns: [Column]) {
        self.sounds = sounds
        self.columns = columns
        self.cells = columns.map(ChartColumnsStackViewCell.init(column:))
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    private func setup() {
        cells.forEach { cell in
            cell.addTarget(self, action: #selector(cellPressed), for: .touchUpInside)
            cell.isSelected = true
            cell.theme = theme
            stackView.addArrangedSubview(cell)
        }

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.frame = bounds
        addSubview(stackView)
    }

    @objc private func cellPressed(_ cell: ChartColumnsStackViewCell) {
        guard !cell.isSelected || enabledColumns.count > 1 else {
            cell.layer.shake()
            sounds.play(.errorFeedback)
            return
        }

        cell.isSelected.toggle()
        delegate?.columnsView(self, didChangeEnabledColumns: enabledColumns)
    }

    private func canDisableColumn() -> Bool {
        return cells.filter { $0.isSelected }.count > 1
    }

    override func themeUp() {
        super.themeUp()
        cells.theme(with: theme)
    }

    private let sounds: SoundService
    private let stackView = UIStackView()
    private let cells: [ChartColumnsStackViewCell]
    private let columns: [Column]
}