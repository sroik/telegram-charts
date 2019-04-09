//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartBrowserFactory {
    static func view(for chart: Chart) -> ChartBrowserView {
        return TimelineChartBrowserView(
            chart: chart,
            chartView: LineChartView(chart: chart),
            gridView: ChartGridView(chart: chart),
            timelineView: ChartTimelineView(chart: chart),
            cardView: ChartCardView(chart: chart)
        )
    }
}
