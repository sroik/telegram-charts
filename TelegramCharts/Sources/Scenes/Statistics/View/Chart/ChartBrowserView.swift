//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartBrowserView: View, Viewportable {
    var viewport: Viewport = .zeroToOne {
        didSet {
            adaptViewport()
        }
    }

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()

        let timelineHeight = timelineView.intrinsicContentSize.height
        workspace.frame = bounds.remainder(at: timelineHeight, from: .maxYEdge)
        timelineView.frame = insets.inset(bounds).slice(at: timelineHeight, from: .maxYEdge)
        gridView.frame = workspace.bounds.inset(by: insets)
        chartView.frame = workspace.bounds.inset(by: insets)
    }

    override func themeUp() {
        super.themeUp()
        pointLine.backgroundColor = theme.color.gridLine
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        chartView.set(enabledColumns: enabledColumns, animated: animated)
        gridView.set(enabledColumns: enabledColumns, animated: animated)
    }

    func adaptViewport() {
        chartView.viewport = viewport
        timelineView.viewport = viewport
        gridView.viewport = viewport
        deselectIndex(animated: true)
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
        selectedIndex = index
        chartView.select(index: index)

        guard let index = selectedIndex else {
            pointLine.set(alpha: 0, animated: animated)
            cardView.set(alpha: 0, animated: animated)
            return
        }

        pointLine.set(alpha: 1, animated: animated)
        pointLine.set(frame: pointLineFrame, animated: animated)

        cardView.set(alpha: 1, animated: animated)
        cardView.index = index
        cardView.shift(to: cardFrame, animated: animated)
    }

    private func setup() {
        timelineView.clipsToBounds = true
        workspace.clipsToBounds = true
        workspace.addSubviews(chartView, gridView, cardView)
        addSubviews(pointLine, workspace, timelineView)
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
        selectIndex(at: point, animated: false)
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
        guard let index = selectedIndex else {
            return .zero
        }

        let chartSize = chartView.contentSize
        let stride = chartSize.width / CGFloat(chart.timestamps.count)
        let center = (CGFloat(index) + 0.5) * stride
        let frame = CGRect(midX: center, width: .pixel, height: chartSize.height)
        return convert(frame, from: chartView.contentView)
    }

    private var selectedIndex: Int?
    private let pointLine = UIView()

    private lazy var workspace = View()
    private lazy var gridView = ChartGridView(chart: chart)
    private lazy var cardView = ChartCardView(chart: chart)
    private lazy var timelineView = ChartTimelineView(chart: chart)
    private lazy var chartView = ChartView(chart: chart)
    private let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    private let chart: Chart
}
