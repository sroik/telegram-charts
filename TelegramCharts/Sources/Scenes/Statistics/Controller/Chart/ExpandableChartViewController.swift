//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ExpandableChartViewController: ChartViewController {
    override func expand(at index: Int, in viewport: Viewport) {
        guard let chart = dependencies.charts.expanded(chart: chart, at: index) else {
            assertionFailureWrapper("failed to expand chart", self.chart.title)
            return
        }

        let controller = ChartViewControllerFactory.controller(
            with: chart,
            dependencies: dependencies
        )

        controller.theme = theme
        controller.delegate = self
        controller.enable(columns: enabledColumns.ids)
        add(child: controller, withAnimator: CrossDissolveLayoutAnimator())
    }
}

extension ExpandableChartViewController: ChartViewControllerDelegate {
    func chartViewControllerWantsToFold(_ controller: ChartViewController) {
        enable(columns: controller.enabledColumns.ids, animated: false)
        controller.dropFromParent(withAnimator: CrossDissolveLayoutAnimator())
    }
}
