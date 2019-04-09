//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartGridViewFactory {
    static func view(with chart: Chart) -> ChartViewportableView {
        if chart.yScaled {
            return ComparingChartGridView(chart: chart)
        }

        return RangeChartGridView(chart: chart)
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
