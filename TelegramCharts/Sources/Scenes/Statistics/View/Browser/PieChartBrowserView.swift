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

        cardView.value = chartView.stackedValue()
        cardView.set(alpha: 1, animated: animated)
        cardView.shift(to: cardFrame, animated: animated)
    }

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: chartView)
        let column = chartView.column(at: point)
        select(column: column, animated: true)
    }

    private func setup() {
        addSubviews(chartView, cardView)
        chartView.addGestureRecognizer(tapRecognizer)
        cardView.alpha = 0
    }

    private var selectedColumn: String? {
        return chartView.selectedColumn
    }

    private var cardFrame: CGRect {
        let center = bounds.center
        let size = cardView.size
        return CGRect(center: center, size: size)
    }

    private lazy var tapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(onTap)
    )
}
