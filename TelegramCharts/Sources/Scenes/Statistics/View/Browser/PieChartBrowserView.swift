//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieChartBrowserView: View, ChartBrowser {
    let chartView: PieChartView
    let insets: UIEdgeInsets
    let cardView: PieChartCardView

    var viewport: Viewport = .zeroToOne {
        didSet {
            adaptViewport()
        }
    }

    init(chartView: PieChartView) {
        self.chartView = chartView
        self.insets = UIEdgeInsets(top: 15, left: 15, bottom: 25, right: 15)
        self.cardView = PieChartCardView(chart: chartView.chart)
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartView.frame = insets.inset(bounds)
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
    }

    func enable(columns: [String], animated: Bool) {
        deselect(animated: animated)
        chartView.enable(columns: columns, animated: animated)
    }

    func adaptViewport() {
        chartView.viewport = viewport
        deselect(animated: true)
    }

    func deselect(animated: Bool) {
        select(column: nil, animated: animated)
    }

    func select(column: String?, animated: Bool) {
        guard column != selectedColumn else {
            return
        }

        chartView.select(column: column, animated: animated)

        guard column != nil else {
            cardView.set(alpha: 0, animated: animated)
            return
        }

        cardView.value = chartView.selectedColumnValue()
        cardView.set(frame: cardFrame, animated: animated, duration: .defaultDuration)
        cardView.set(alpha: 1, animated: animated)
    }

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: chartView)
        let column = chartView.column(at: point)
        let same = column == chartView.selectedColumn
        same ? deselect(animated: true) : select(column: column, animated: true)
    }

    private func setup() {
        addSubview(chartView)
        chartView.addSubview(cardView)
        chartView.addGestureRecognizer(tapRecognizer)
        cardView.alpha = 0
    }

    private var selectedColumn: String? {
        return chartView.selectedColumn
    }

    private var cardFrame: CGRect {
        guard let column = chartView.selectedColumn else {
            return .zero
        }

        let sliceBox = chartView.visualPath(of: column).bounds
        let size = cardView.size
        let isPinnedToTop = sliceBox.midY > chartView.bounds.midY
        let minY = isPinnedToTop ?
            sliceBox.minY - size.height - 10 :
            sliceBox.maxY + 10

        return CGRect(
            midX: sliceBox.midX,
            y: minY,
            size: size
        ).limited(with: chartView.bounds)
    }

    private lazy var tapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(onTap)
    )
}
