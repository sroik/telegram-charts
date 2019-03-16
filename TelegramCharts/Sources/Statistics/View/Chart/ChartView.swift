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
        selectedLine.backgroundColor = theme.color.line
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

        chartLayer.frame = chartFrame
        timestampsView.frame = timestampsFrame
        displayValue(at: selectedIndex)
    }

    private func selectIndex(at point: CGPoint) {
        let position = point.x / scrollView.contentSize.width
        selectedIndex = chart.timestamps.index(nearestTo: position, strategy: .ceil)
        displayValue(at: selectedIndex)
    }

    private func displayValue(at index: Int?) {
        guard let index = index else {
            selectedLine.isHidden = true
            return
        }

        let stride = adaptedContentSize.width / CGFloat(chart.timestamps.count)
        selectedLine.isHidden = false
        selectedLine.frame = CGRect(
            x: (CGFloat(index) + 0.5) * stride,
            y: 0,
            width: .pixel,
            height: adaptedContentSize.height
        )
    }

    private func setup() {
        gridView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))
        scrollView.fill(in: self)
        valuesView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))

        scrollView.addSubview(selectedLine)
        scrollView.layer.addSublayer(chartLayer)
        scrollView.addSubview(timestampsView)

        set(enabledColumns: Set(chart.drawableColumns))
        set(range: chart.drawableColumns.range)
        setupGestures()
        adaptViewport()
    }

    private func setupGestures() {
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(onPan))
        pan.minimumPressDuration = 0.25
        pan.allowableMovement = CGRect.screen.diagonal
        scrollView.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        scrollView.addGestureRecognizer(tap)
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

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        selectIndex(at: recognizer.location(in: scrollView))
    }

    @objc private func onPan(_ recognizer: UILongPressGestureRecognizer) {
        selectIndex(at: recognizer.location(in: scrollView))
    }

    private var selectedIndex: Int?
    private let selectedLine = UIView()
    private let timestampsHeight: CGFloat = 25
    private let gridView = ChartGridView()
    private let valuesView: ChartValuesView
    private let timestampsView: ChartTimestampsView
    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
