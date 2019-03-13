//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartView: View {
    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    private func setup() {
        scrollView.fill(in: self)
    }

    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
