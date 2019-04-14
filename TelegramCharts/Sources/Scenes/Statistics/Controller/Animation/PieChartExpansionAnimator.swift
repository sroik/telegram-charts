//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class PieChartExpansionAnimator: UIViewController.LayoutAnimator {
    let duration: TimeInterval

    init(duration: TimeInterval = 2.0) {
        self.duration = duration
    }

    func animate(
        with context: UIViewController.LayoutAnimator.Context,
        completion: @escaping UIViewController.LayoutAnimator.Completion
    ) {
        guard
            let from = context.parent as? ExpandableChartViewController,
            let to = context.child as? ChartViewController
        else {
            assertionFailureWrapper("invalid types")
            completion()
            return
        }

        completion()
    }
}
