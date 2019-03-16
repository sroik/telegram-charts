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
        workspace.theme = theme
        timestampsView.theme = theme
    }

    private func setup() {
        scrollView.fill(in: self)
        scrollView.addSubview(workspace)
        scrollView.addSubview(timestampsView)
        workspace.layer.addSublayer(chartLayer)
        valuesView.fill(in: workspace)
        set(enabledColumns: Set(chart.drawableColumns))
        set(range: chart.drawableColumns.range)
        adaptViewport()
    }

    func set(range: Range<Int>, animated: Bool = false) {
        chartLayer.set(range: range, animated: animated)
        valuesView.set(range: range, animated: animated)
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        chartLayer.set(enabledColumns: enabledColumns, animated: animated)
    }

    private func adaptViewport() {
        scrollView.contentSize = adaptedContentSize
        scrollView.contentOffset = CGPoint(x: adaptedContentSize.width * viewport.min, y: 0)

        workspace.frame = workspaceFrame
        timestampsView.frame = timestampsFrame
        chartLayer.frame = workspace.bounds
    }

    private var workspaceFrame: CGRect {
        return CGRect(
            x: 0, y: 0,
            width: adaptedContentSize.width,
            height: adaptedContentSize.height - timestampsHeight - timestampsOffset
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

    private let timestampsHeight: CGFloat = 20
    private let timestampsOffset: CGFloat = 5
    private let workspace = View()
    private let valuesView: ChartValuesView
    private let timestampsView: ChartTimestampsView
    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
