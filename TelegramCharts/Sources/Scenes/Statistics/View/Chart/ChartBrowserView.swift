//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartBrowserView: View, Viewportable {
    let chart: Chart

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

        let insets = UIEdgeInsets(right: 15, left: 15)
        let contentFrame = bounds.inset(by: insets)
        gridView.frame = contentFrame.remainder(at: timestampsHeight, from: .maxYEdge)
        chartView.frame = contentFrame.remainder(at: timestampsHeight, from: .maxYEdge)
        timestampsView.frame = contentFrame.slice(at: timestampsHeight, from: .maxYEdge)
    }

    override func themeUp() {
        super.themeUp()
        selectedLine.backgroundColor = theme.color.gridLine
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        chartView.set(enabledColumns: enabledColumns, animated: animated)
    }

    func adaptViewport() {
        chartView.viewport = viewport
        timestampsView.viewport = viewport
        deselectIndex()
    }

    private func deselectIndex() {
        select(index: nil)
    }

    private func selectIndex(at point: CGPoint) {
        let chartPoint = convert(point, to: chartView.contentView)
        let position = chartPoint.x / chartView.contentSize.width
        select(index: chart.timestamps.index(nearestTo: position, strategy: .ceil))
    }

    private func select(index: Int?) {
        selectedIndex = index
        chartView.select(index: index)
        displayValue(at: index)
    }

    private func displayValue(at index: Int?) {
        guard let index = index else {
            selectedLine.set(alpha: 0, duration: 0.2)
            cardView.set(alpha: 0, duration: 0.2)
            return
        }

        let contentSize = chartView.contentSize
        let stride = contentSize.width / CGFloat(chart.timestamps.count)
        let centerX = (CGFloat(index) + 0.5) * stride

        let lineFrame = CGRect(midX: centerX, width: .pixel, height: contentSize.height)
        selectedLine.set(alpha: 1, duration: 0.2)
        selectedLine.frame = convert(lineFrame, from: chartView.contentView)

        cardView.set(alpha: 1, duration: 0.2)
        cardView.index = index

        let cardFrame = CGRect(midX: centerX, size: cardView.intrinsicContentSize)
        cardView.frame = convert(cardFrame, from: chartView.contentView)
        limitValueCardFrame()
    }

    private func limitValueCardFrame() {
        let limits = UIEdgeInsets(right: 15, left: 50).inset(bounds)
        cardView.frame = cardView.frame.limited(with: limits)
    }

    private func setup() {
        timestampsView.clipsToBounds = true
        addSubviews(selectedLine, chartView, gridView, timestampsView, cardView)
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
        let isInCard = cardView.frame.contains(point) && cardView.isVisible
        isInCard ? deselectIndex() : selectIndex(at: point)
    }

    @objc private func onPan(_ recognizer: UILongPressGestureRecognizer) {
        selectIndex(at: recognizer.location(in: self))
    }

    private var selectedIndex: Int?
    private let selectedLine = UIView()

    private lazy var gridView = ChartGridView(range: chartView.range)
    private lazy var cardView = ChartCardView(chart: chart)
    private lazy var timestampsView = ChartTimestampsView(timestamps: chart.timestamps)
    private lazy var chartView = ChartView(chart: chart)
    private let timestampsHeight: CGFloat = 25
}
