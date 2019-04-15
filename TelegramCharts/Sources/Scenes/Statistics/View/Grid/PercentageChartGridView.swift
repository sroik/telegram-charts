//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PercentageChartGridView: RangeChartGridView {
    override func adaptedLayout() -> GridLayout {
        return GridLayout(
            itemSide: .fixed(20),
            itemsNumber: 5,
            insets: UIEdgeInsets(top: -20),
            direction: .vertical
        )
    }

    override func adaptedRange() -> Range<Int> {
        return Range(min: 0, max: 100)
    }

    override func setup() {
        super.setup()
        clipsToBounds = false
    }
}
