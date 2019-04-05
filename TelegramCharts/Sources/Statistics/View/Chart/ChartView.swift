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
        self.valueCard = ChartValueCardView(chart: chart)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adaptViewport()
    }

    override func themeUp() {
        super.themeUp()
        chartLayer.theme = theme
        scrollView.subviews.theme(with: theme)
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
        scrollView.contentSize = contentSize
        scrollView.contentOffset = CGPoint(x: contentSize.width * viewport.min, y: 0)

        chartLayer.frame = chartFrame
        timestampsView.frame = timestampsFrame
        displayValue(at: selectedIndex)
    }

    private func deselectIndex() {
        select(index: nil)
    }

    private func selectIndex(at point: CGPoint) {
        let position = point.x / scrollView.contentSize.width
        select(index: chart.timestamps.index(nearestTo: position, strategy: .ceil))
    }

    private func select(index: Int?) {
        selectedIndex = index
        chartLayer.select(index: index)
        displayValue(at: index)
    }

    private func displayValue(at index: Int?) {
        guard let index = index else {
            selectedLine.isHidden = true
            valueCard.isHidden = true
            return
        }

        let stride = contentSize.width / CGFloat(chart.timestamps.count)
        let centerX = (CGFloat(index) + 0.5) * stride

        selectedLine.isHidden = false
        selectedLine.frame = CGRect(midX: centerX, width: .pixel, height: contentSize.height)

        valueCard.index = index
        valueCard.isHidden = false
        valueCard.frame = CGRect(midX: centerX, size: valueCard.intrinsicContentSize)
        limitValueCardFrame()
    }

    private func limitValueCardFrame() {
        valueCard.frame = valueCard.frame.limited(with: scrollView.visibleRect)
    }

    private func setup() {
        gridView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))
        scrollView.fill(in: self)
        valuesView.fill(in: self, insets: UIEdgeInsets(bottom: timestampsHeight))

        scrollView.addSubview(selectedLine)
        scrollView.layer.addSublayer(chartLayer)
        scrollView.addSubview(timestampsView)
        scrollView.addSubview(valueCard)

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
            width: contentSize.width,
            height: contentSize.height - timestampsHeight
        )
    }

    private var timestampsFrame: CGRect {
        return CGRect(
            x: 0,
            y: contentSize.height - timestampsHeight,
            width: contentSize.width,
            height: timestampsHeight
        )
    }

    private var contentSize: CGSize {
        return CGSize(
            width: bounds.width / viewport.size,
            height: bounds.height
        )
    }

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: scrollView)
        let isInCard = valueCard.frame.contains(point) && !valueCard.isHidden
        isInCard ? deselectIndex() : selectIndex(at: point)
    }

    @objc private func onPan(_ recognizer: UILongPressGestureRecognizer) {
        selectIndex(at: recognizer.location(in: scrollView))
    }

    private var selectedIndex: Int?
    private let selectedLine = UIView()
    private let valueCard: ChartValueCardView

    private let timestampsHeight: CGFloat = 25
    private let gridView = ChartGridView()
    private let valuesView: ChartValuesView
    private let timestampsView: ChartTimestampsView
    private let chartLayer: ChartLayer
    private let scrollView = UIScrollView.charts()
    private let chart: Chart
}
