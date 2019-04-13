//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

struct ChartViewControllerFactory {
    typealias Dependencies = ChartViewController.Dependencies

    static func controller(
        with chart: Chart,
        dependencies: Dependencies
    ) -> ExpandableChartViewController {
        return ExpandableChartViewController(
            dependencies: dependencies,
            chart: chart
        )
    }

    static func controller(
        expandedFrom expandable: ExpandableChartViewController,
        at index: Int,
        with chart: Chart,
        dependencies: Dependencies
    ) -> ChartViewController {
        let controller = ChartViewController(dependencies: dependencies, chart: chart)
        controller.set(viewport: Range(mid: 0.5, size: chart.preferredViewportSize))
        expandable.moveState(from: expandable, to: controller)
        return controller
    }
}

extension ChartViewController {
    convenience init(dependencies: Dependencies, chart: Chart) {
        self.init(
            dependencies: dependencies,
            layout: ChartViewControllerLayout(chart: chart),
            chart: chart,
            chartView: ChartBrowserFactory.view(with: chart),
            mapView: ChartMapViewFactory.view(with: chart)
        )
    }
}
