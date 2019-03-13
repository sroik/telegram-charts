//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartView: View {
    var viewport: Range<CGFloat> = Range(min: 0.8, max: 1.0) {
        didSet {
            adaptToViewport()
        }
    }

    var enabledColumns: Set<Column> {
        didSet {
            chartLayer.enabledColumns = enabledColumns
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.enabledColumns = Set(chart.drawableColumns)
        self.chartLayer = ChartLayer(chart: chart)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adaptToViewport()
    }

    private func setup() {
        scrollView.fill(in: self)
        scrollView.layer.addSublayer(chartLayer)
        chartLayer.lineWidth = 2
        adaptToViewport()
    }

    private func adaptToViewport() {
        scrollView.contentSize = CGSize(
            width: bounds.width / viewport.size,
            height: bounds.height
        )

        scrollView.contentOffset = CGPoint(
            x: scrollView.contentSize.width * viewport.min,
            y: 0
        )

        chartLayer.frame = CGRect(origin: .zero, size: scrollView.contentSize)
    }

    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
