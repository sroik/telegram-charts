//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartCardView: CardView {
    let titleCell: ChartCardViewCell
    let columnCells: [ChartCardViewCell]
    let chart: Chart

    var index: Int = 0 {
        didSet {
            update()
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.titleCell = ChartCardViewCell()
        self.columnCells = []
        super.init(items: [titleCell])
    }

    private func update() {
        titleCell.summary = date?.string(format: "E, d MMM yyyy")
//        chart.drawableColumns.forEach { column in
//            if let value = column.values[safe: index] {
//                labels[column.label]?.text = String(value)
//            }
//        }
    }

    private var date: Date? {
        return timestamp.flatMap(Date.init(timestamp:))
    }

    private var timestamp: Timestamp? {
        return chart.timestamps[safe: index]
    }
}
