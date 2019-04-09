//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartBrowserFactory {
    static func view(with chart: Chart) -> ChartBrowserView {
        return TimelineChartBrowserView(
            chart: chart,
            chartView: ChartViewFactory.view(with: chart),
            gridView: ChartGridViewFactory.view(with: chart),
            timelineView: TimelineView(chart: chart),
            cardView: ChartCardView(chart: chart)
        )
    }
}
