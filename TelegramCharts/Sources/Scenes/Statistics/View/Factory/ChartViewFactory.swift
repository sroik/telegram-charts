//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartViewFactory {
    static func view(with chart: Chart) -> LineChartView {
        if chart.yScaled {
            return ComparingLineChartView(chart: chart)
        }

        return LineChartView(chart: chart)
    }
}
