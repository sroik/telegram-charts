//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct ChartBrowserFactory {
    static func view(with chart: Chart) -> ChartBrowserView {
        return TimelineChartBrowserView(
            chart: chart,
            layout: ChartBrowserLayoutFactory.layout(with: chart),
            chartView: ChartViewFactory.view(with: chart),
            gridView: ChartGridViewFactory.view(with: chart),
            timelineView: TimelineView(chart: chart),
            cardView: CardCardViewFactory.card(with: chart)
        )
    }
}

struct ChartBrowserLayoutFactory {
    static func layout(with chart: Chart) -> TimelineChartBrowserLayout {
        if chart.percentage {
            return TimelineChartBrowserLayout(
                lineWidth: 2 * .pixel,
                isOnLineTop: true,
                cardTopOffset: 5
            )
        }

        return TimelineChartBrowserLayout()
    }
}

struct CardCardViewFactory {
    static func card(with chart: Chart) -> ChartCardView {
        if chart.stacked {
            return StackedChartCardView(chart: chart)
        }

        return ChartCardView(chart: chart)
    }
}
