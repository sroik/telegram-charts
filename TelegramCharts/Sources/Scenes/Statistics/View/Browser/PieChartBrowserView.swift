//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

final class PieChartBrowserView: View, ChartBrowser {
    let chartView: PieChartView

    var viewport: Viewport {
        didSet {
            adaptViewport()
        }
    }

    init(chartView: PieChartView) {
        self.chartView = chartView
        self.viewport = .zeroToOne
        super.init(frame: .zero)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartView.frame = bounds
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
    }

    func enable(columns: [String], animated: Bool) {}
    func adaptViewport() {}
    func deselect(animated: Bool) {}

    private func setup() {
        addSubview(chartView)
    }
}
