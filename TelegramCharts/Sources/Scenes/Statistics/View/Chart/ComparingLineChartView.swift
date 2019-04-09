//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ComparingLineChartView: LineChartView {
    override func adaptRange(animated: Bool) {
        layers.forEach { layer in
            layer.set(
                range: chart.adjustedRange(of: layer.column, in: viewport),
                animated: animated
            )
        }
    }
}
