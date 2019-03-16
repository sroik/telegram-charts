//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartView: View {
    var viewport: Range<CGFloat> {
        didSet {
            adaptViewport()
        }
    }

    var range: Range<Int> {
        return chartLayer.range
    }

    init(chart: Chart) {
        self.chart = chart
        self.chartLayer = ChartLayer(chart: chart)
        self.timestampsView = ChartTimestampsView(timestamps: chart.timestamps)
        self.viewport = Range(min: 0.8, max: 1.0)
        self.valuesView = ChartValuesView(range: chartLayer.range)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adaptViewport()
    }

    override func themeUp() {
        super.themeUp()
        valuesView.theme = theme
        timestampsView.theme = theme
    }

    private func setup() {
        gridView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))
        scrollView.fill(in: self)
        valuesView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))

        scrollView.layer.addSublayer(chartLayer)
        scrollView.addSubview(timestampsView)

        set(enabledColumns: Set(chart.drawableColumns))
        set(range: chart.drawableColumns.range)
        adaptViewport()
    }

    func set(range: Range<Int>, animated: Bool = false) {
        /* let's scale range a little to make it look better */
        let scaledRange = range.scale(by: 1.1)
        chartLayer.set(range: scaledRange, animated: animated)
        valuesView.set(range: scaledRange, animated: animated)
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        chartLayer.set(enabledColumns: enabledColumns, animated: animated)
    }

    private func adaptViewport() {
        scrollView.contentSize = adaptedContentSize
        scrollView.contentOffset = CGPoint(x: adaptedContentSize.width * viewport.min, y: 0)

        chartLayer.frame = chartFrame
        timestampsView.frame = timestampsFrame
    }

    private var chartFrame: CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: adaptedContentSize.width,
            height: adaptedContentSize.height - timestampsHeight
        )
    }

    private var timestampsFrame: CGRect {
        return CGRect(
            x: 0,
            y: adaptedContentSize.height - timestampsHeight,
            width: adaptedContentSize.width,
            height: timestampsHeight
        )
    }

    private var adaptedContentSize: CGSize {
        return CGSize(
            width: bounds.width / viewport.size,
            height: bounds.height
        )
    }

    private let timestampsHeight: CGFloat = 25
    private let gridView = ChartGridView()
    private let valuesView: ChartValuesView
    private let timestampsView: ChartTimestampsView
    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
