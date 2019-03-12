//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartViewDelegate: AnyObject {}

final class ChartView: View {
    weak var delegate: ChartViewDelegate?

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        scrollView.fill(in: self)
    }

    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
