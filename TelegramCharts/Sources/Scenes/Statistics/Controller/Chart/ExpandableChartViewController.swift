//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ExpandableChartViewController: ChartViewController {
    override func expand(at index: Int) {
        guard let timestamp = chart.timestamps[safe: index] else {
            assertionFailureWrapper("invalid index to expand", String(index))
            return
        }

        guard let chart = dependencies.charts.expanded(chart: chart, at: index) else {
            assertionFailureWrapper("failed to expand chart", self.chart.title)
            return
        }

        let controller = ChartViewControllerFactory.controller(
            expandedFrom: self,
            at: timestamp,
            with: chart,
            dependencies: dependencies
        )

        controller.delegate = self
        add(child: controller, withAnimator: CrossDissolveLayoutAnimator())
    }

    func moveState(from: ChartViewController, to: ChartViewController) {
        to.theme = from.theme

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
