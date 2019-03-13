//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartColumnsStackViewDelegate: AnyObject {}

final class ChartColumnsStackView: View {
    weak var delegate: ChartColumnsStackViewDelegate?

    init(columns: [Column]) {
        self.columns = columns
        self.cells = columns.map(ChartColumnsStackViewCell.init(column:))
        super.init(frame: .zero)
    }

    private func setup() {
        cells.forEach { cell in
            cell.addTarget(self, action: #selector(cellPressed), for: .touchUpInside)
            cell.isSelected = true
            stackView.addArrangedSubview(cell)
        }

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.fill(in: self)
    }

    @objc private func cellPressed(_ cell: ChartColumnsStackViewCell) {
        cell.isSelected.toggle()
    }

    private let stackView = UIStackView()
    private let cells: [ChartColumnsStackViewCell]
    private let columns: [Column]
}
