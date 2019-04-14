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
        at timestamp: Timestamp,
        with chart: Chart,
        dependencies: Dependencies
    ) -> ChartViewController {
        let viewport = chart.viewport(toCover: timestamp)
        let controller = ChartViewController(dependencies: dependencies, chart: chart)
        controller.set(viewport: viewport)
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
            mapView: ChartMapViewFactory.view(with: chart, sounds: dependencies.sounds)
        )
    }
}
