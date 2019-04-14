//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class PieChartCardView: CardView {
    var value: StackedColumnValue? {
        didSet {
            update()
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.cell = ChartCardViewCell()
        super.init(items: [cell])
    }

    func update() {
        guard let columnValue = value else {
            return
        }

        cell.valueColor = columnValue.color.flatMap(UIColor.init(cgColor:))
        cell.value = String(value: columnValue.value)
        cell.title = chart.column(with: columnValue.id)?.name
    }

    private let cell: ChartCardViewCell
    private let chart: Chart
}
