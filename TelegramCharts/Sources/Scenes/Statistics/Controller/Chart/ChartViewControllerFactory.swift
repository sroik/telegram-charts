//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

struct ChartViewControllerFactory {
    typealias Dependencies = ChartViewController.Dependencies

    static func controller(
        with chart: Chart,
        dependencies: Dependencies
    ) -> ChartViewController {
        if chart.expandable {
            return expandableController(with: chart, dependencies: dependencies)
        }

        return expandedController(with: chart, dependencies: dependencies)
    }

    private static func expandableController(
        with chart: Chart,
        dependencies: Dependencies
    ) -> ExpandableChartViewController {
        return ExpandableChartViewController(dependencies: dependencies, chart: chart)
    }

    private static func expandedController(
        with chart: Chart,
        dependencies: Dependencies
    ) -> ChartViewController {
        return ChartViewController(dependencies: dependencies, chart: chart)
    }
}
