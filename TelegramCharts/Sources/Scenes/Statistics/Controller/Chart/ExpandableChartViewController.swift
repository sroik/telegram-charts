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
        moveState(from: self, to: controller)
        add(child: controller, withAnimator: CrossDissolveLayoutAnimator())
    }

    func moveState(from: ChartViewController, to: ChartViewController) {
        if from.chart.columns.ids == to.chart.columns.ids {
            to.enable(columns: from.columnsView.enabledColumns.ids)
        }
    }
}

extension ExpandableChartViewController: ChartViewControllerDelegate {
    func chartViewControllerWantsToFold(_ controller: ChartViewController) {
        moveState(from: controller, to: self)
        controller.dropFromParent(withAnimator: CrossDissolveLayoutAnimator())
    }
}
