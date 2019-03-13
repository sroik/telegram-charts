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

    init(columns: [Column]) {
        self.columns = columns
        self.cells = columns.map(ChartColumnsStackViewCell.init(column:))
        super.init(frame: .screen)
        setup()
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
        stackView.fill(in: self)
    }

    @objc private func cellPressed(_ cell: ChartColumnsStackViewCell) {
        cell.isSelected.toggle()
        delegate?.columnsView(self, didChangeEnabledColumns: enabledColumns)
    }

    override func themeUp() {
        super.themeUp()
        cells.theme(with: theme)
    }

    private let stackView = UIStackView()
    private let cells: [ChartColumnsStackViewCell]
    private let columns: [Column]
}
