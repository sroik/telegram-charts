//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PercentageChartGridView: RangeChartGridView {
    convenience init(chart: Chart) {
        self.init(chart: chart, layout: .percentage)
    }

    override func adaptedRange() -> Range<Int> {
        return Range(min: 0, max: 100)
    }

    override func setup() {
        super.setup()
        clipsToBounds = false
    }
}

private extension GridLayout {
    static let percentage = GridLayout(
        itemSide: .fixed(20),
        itemsNumber: 5,
        insets: UIEdgeInsets(top: -20),
        direction: .vertical
    )
}
