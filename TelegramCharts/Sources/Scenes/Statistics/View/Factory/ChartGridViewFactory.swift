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
            return ComparingChartGridView(chart: chart)
        }

        return RangeChartGridView(chart: chart)
    }
}
