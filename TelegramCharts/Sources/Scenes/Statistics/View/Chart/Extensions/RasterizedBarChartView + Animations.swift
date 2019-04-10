//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension RasterizedBarChartView {
    func animateColumns(from: [Column], to: [Column], animated: Bool) {
        guard animated, minViewportSize < 1 else {
            return
        }

        barChartView.viewport = viewport
        barChartView.fill(in: self)
        barChartView.layoutIfNeeded()
        barChartView.layoutLayers()

        barChartView.enable(columns: from, animated: false)
        barChartView.enable(columns: to, animated: true)

        imageView.isHidden = true
        contentView.backgroundColor = .clear
        bringSubviewToFront(contentView)

        after(.smoothDuration) {
            self.imageView.isHidden = false
            self.contentView.backgroundColor = self.theme.color.placeholder
            self.barChartView.removeFromSuperview()
        }
    }
}
