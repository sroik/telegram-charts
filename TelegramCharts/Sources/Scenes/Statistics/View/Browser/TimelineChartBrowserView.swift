//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class TimelineChartBrowserView: ViewportView, ExpandableChartBrowser {
    weak var delegate: ChartBrowserDelegate?
    var gridView: ChartViewportableView
    var chartView: TimelineChartView
    let timelineView: TimelineView
    let pointLine = UIView()
    let cardView: ChartCardView
    let chartContainer = View()
    let layout: TimelineChartBrowserLayout
    let chart: Chart

    init(
        chart: Chart,
        layout: TimelineChartBrowserLayout,
        chartView: TimelineChartView,
        gridView: ChartViewportableView,
        timelineView: TimelineView,
        cardView: ChartCardView
    ) {
        self.chartView = chartView
        self.gridView = gridView
        self.timelineView = timelineView
        self.cardView = cardView
        self.chart = chart
        self.layout = layout
        super.init(autolayouts: false)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()

        timelineView.frame = layout.timelineFrame(in: bounds)
        gridView.frame = layout.gridFrame(in: bounds)
        chartContainer.frame = layout.chartContainerFrame(in: bounds)
        chartView.frame = layout.chartFrame(in: bounds)
    }

    override func themeUp() {
        super.themeUp()
        pointLine.backgroundColor = theme.color.gridLine
        backgroundColor = theme.color.placeholder
    }

    override func adaptViewport() {
        super.adaptViewport()
        deselect(animated: true)
        chartView.viewport = viewport
        timelineView.viewport = viewport
        gridView.viewport = viewport
    }

    func enable(columns: [String], animated: Bool = false) {
        chartView.enable(columns: columns, animated: animated)
        gridView.enable(columns: columns, animated: animated)
        cardView.enable(columns: columns, animated: animated)
        layoutCard(animated: animated)
    }

    func deselect(animated: Bool) {
        select(index: nil, animated: animated)
    }

    private func selectIndex(at point: CGPoint, animated: Bool) {
        let chartPoint = point.x - chartView.offset - layout.insets.left
        let position = chartPoint / chartView.contentSize.width
        let index = chart.timestamps.index(nearestTo: position)
        select(index: index, animated: animated)
    }

    private func select(index: Int?, animated: Bool) {
        chartView.selectedIndex = index

        guard let index = index else {
            pointLine.set(alpha: 0, animated: animated)
            cardView.set(alpha: 0, animated: animated)
            return
        }

        cardView.selectedIndex = index
        layoutCard(animated: animated)
        pointLine.set(alpha: 1, animated: animated)
        cardView.set(alpha: 1, animated: animated)
    }

    private func layoutCard(animated: Bool) {
        pointLine.set(frame: lineFrame, animated: animated)
        cardView.shift(to: cardFrame, animated: animated)
    }

    private func setup() {
        timelineView.clipsToBounds = true
        chartContainer.clipsToBounds = true
        chartContainer.addSubviews(chartView)
        addSubviews(chartContainer, gridView, cardView, timelineView)
        insertSubview(pointLine, at: layout.isLineOnTop ? 2 : 0)

        let pan = UILongPressGestureRecognizer(target: self, action: #selector(onPan))
        pan.minimumPressDuration = 0.2
        pan.allowableMovement = CGRect.screen.diagonal
        chartContainer.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        chartContainer.addGestureRecognizer(tap)
        cardView.addTarget(self, action: #selector(cardPressed), for: .touchUpInside)
    }

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        selectIndex(at: point, animated: cardView.isVisible)
    }

    @objc private func onPan(_ recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        selectIndex(at: point, animated: cardView.isVisible)
    }

    @objc private func cardPressed() {
        if let index = chartView.selectedIndex, chart.expandable {
            deselect(animated: true)
            delegate?.chartBrowser(self, wantsToExpand: index)
        } else {
            deselect(animated: true)
        }
    }

    private var cardFrame: CGRect {
        return layout.cardFrame(size: cardView.size, in: bounds, lineCenter: lineFrame.midX)
    }

    private var lineFrame: CGRect {
        guard let index = chartView.selectedIndex else {
            return .zero
        }

        let chartSize = chartView.contentSize
        let stride = chartSize.width / CGFloat(chart.timestamps.count)
        let inChartCenter = (CGFloat(index) + 0.5) * stride
        let center = inChartCenter + chartView.offset + layout.insets.left
        return layout.lineFrame(in: bounds, centerX: center)
    }
}
