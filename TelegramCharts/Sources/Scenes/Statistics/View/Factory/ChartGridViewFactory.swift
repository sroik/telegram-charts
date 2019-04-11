//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartGridViewFactory {
    static func view(with chart: Chart) -> ChartViewportableView {
        if chart.percentage {
            return PercentageChartGridView(chart: chart)
        }

        if chart.yScaled {
            return ComparingChartGridView(chart: chart, layout: .values)
        }

        return RangeChartGridView(chart: chart, layout: .values)
    }
}

extension GridLayout {
    static let values = GridLayout(
        itemSide: .fixed(20),
        itemsNumber: 6,
        insets: .zero,
        direction: .vertical
    )
}
