//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct LayoutAnimatorFactory {
    static func animator(with chart: Chart) -> UIViewController.LayoutAnimator {
        switch chart.columnsType {
        case .area where chart.expandable:
            return PieChartExpansionAnimator()
        case .area, .bar, .line, .timestamps:
            return ChartExpansionAnimator()
        }
    }
}
