//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class TimelineChartBrowserView: ViewportView, ChartBrowser {
    init(
        chart: Chart,
        chartView: LineChartView,
        gridView: ChartViewportableView,
        timelineView: TimelineView,
        cardView: ChartCardView
    ) {
        self.chartView = chartView
        self.gridView = gridView
        self.timelineView = timelineView
        self.cardView = cardView
        self.chart = chart
        super.init(autolayouts: false)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()

        let timelineHeight = timelineView.intrinsicContentSize.height
        timelineView.frame = insets.inset(bounds).slice(at: timelineHeight, from: .maxYEdge)
        gridView.frame = insets.inset(bounds).remainder(at: timelineHeight, from: .maxYEdge)
        chartContainer.frame = bounds.remainder(at: timelineHeight, from: .maxYEdge)
        chartView.frame = chartContainer.bounds.inset(by: insets)
    }

    override func themeUp() {
        super.themeUp()
        pointLine.backgroundColor = theme.color.gridLine
    }

    override func adaptViewport() {
        super.adaptViewport()
        deselectIndex(animated: true)
        chartView.viewport = viewport
        timelineView.viewport = viewport
        gridView.viewport = viewport
    }

    func enable(columns: [Column], animated: Bool = false) {
        chartView.enable(columns: columns, animated: animated)
        gridView.enable(columns: columns, animated: animated)
    }

    private func deselectIndex(animated: Bool) {
        select(index: nil, animated: animated)
    }

    private func selectIndex(at point: CGPoint, animated: Bool) {
        let chartPoint = convert(point, to: chartView.contentView)
        let position = chartPoint.x / chartView.contentSize.width
        let index = chart.timestamps.index(nearestTo: position, strategy: .ceil)
        select(index: index, animated: animated)
    }

    private func select(index: Int?, animated: Bool) {
        chartView.select(index: index)

        guard let index = index else {
            pointLine.set(alpha: 0, animated: animated)
            cardView.set(alpha: 0, animated: animated)
            return
        }

        pointLine.set(frame: pointLineFrame, animated: animated)
        pointLine.set(alpha: 1, animated: animated)

        cardView.index = index
        cardView.shift(to: cardFrame, animated: animated)
        cardView.set(alpha: 1, animated: animated)
    }

    private func setup() {
        gridView.clipsToBounds = true
        timelineView.clipsToBounds = true
        chartContainer.clipsToBounds = true
        chartContainer.addSubviews(chartView)
        addSubviews(pointLine, chartContainer, gridView, cardView, timelineView)
        setupGestures()
    }

    private func setupGestures() {
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(onPan))
        pan.minimumPressDuration = 0.2
        pan.allowableMovement = CGRect.screen.diagonal
        chartView.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        chartView.addGestureRecognizer(tap)
    }

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        selectIndex(at: point, animated: cardView.isVisible)
    }

    @objc private func onPan(_ recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        selectIndex(at: point, animated: cardView.isVisible)
    }

    private var cardFrame: CGRect {
        let lineFrame = pointLineFrame
        let limits = bounds.inset(by: insets).inset(left: 35)
        let leftSpace = lineFrame.minX - limits.minX
        let rightSpace = limits.maxX - lineFrame.maxX
        if leftSpace > rightSpace {
            return CGRect(
                maxX: lineFrame.minX - 10,
                size: cardView.size
            ).limited(with: limits)
        } else {
            return CGRect(
                x: lineFrame.maxX + 10,
                size: cardView.size
            ).limited(with: limits)
        }
    }

    private var pointLineFrame: CGRect {
        guard let index = chartView.selectedIndex else {
            return .zero
        }

        let chartSize = chartView.contentSize
        let stride = chartSize.width / CGFloat(chart.timestamps.count)
        let center = (CGFloat(index) + 0.5) * stride
        let frame = CGRect(midX: center, width: .pixel, height: chartSize.height)
        return convert(frame, from: chartView.contentView)
    }

    private var gridView: ChartViewportableView
    private let timelineView: TimelineView
    private let cardView: ChartCardView
    private let pointLine = UIView()
    private let chartView: LineChartView
    private let chartContainer = View()
    private let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    private let chart: Chart
}
