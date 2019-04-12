//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

struct ChartViewControllerFactory {
    static func controller(
        with chart: Chart,
        dependencies: ChartViewController.Dependencies
    ) -> ChartViewController {
        return ChartViewController(
            dependencies: dependencies,
            layout: ChartViewControllerLayout(chart: chart),
            chart: chart,
            chartView: ChartBrowserFactory.view(with: chart),
            mapView: ChartMapViewFactory.view(with: chart)
        )
    }
}
