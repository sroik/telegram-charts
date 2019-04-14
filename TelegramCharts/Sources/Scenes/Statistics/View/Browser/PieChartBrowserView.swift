//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieChartBrowserView: View, ChartBrowser {
    let chartView: PieChartView
    let insets: UIEdgeInsets

    var viewport: Viewport = .zeroToOne {
        didSet {
            adaptViewport()
        }
    }

    init(chartView: PieChartView) {
        self.chartView = chartView
        self.insets = UIEdgeInsets(top: 15, left: 15, bottom: 25, right: 15)
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
        chartView.enable(columns: columns, animated: animated)
    }

    func adaptViewport() {
        chartView.viewport = viewport
    }

    func deselect(animated: Bool) {
        print("CARD REMOVAL")
    }

    private func setup() {
        addSubview(chartView)
    }
}
