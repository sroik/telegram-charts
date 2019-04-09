//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class BarChartView: ViewportView, ChartViewType {
    let chart: Chart

    var selectedIndex: Int? {
        didSet {}
    }

    init(chart: Chart, viewport: Viewport = .zeroToOne) {
        self.chart = chart
        super.init(viewport: viewport)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        adaptRange(animated: false)
    }

    override func adaptViewport() {
        super.adaptViewport()
        /* do smth */
    }

    override func display() {
        super.display()
        adaptRange(animated: true)
    }

    func enable(columns: [Column], animated: Bool) {
        enabledColumns = columns
        adaptRange(animated: animated)
    }

    func adaptRange(animated: Bool) {
        let range = chart.adjustedRange(of: enabledColumns, in: viewport)
        /*  do smth */
    }

    private func setup() {
        contentView.backgroundColor = .blue
        enable(columns: chart.drawableColumns, animated: false)
    }

    private(set) var enabledColumns: [Column] = []
}
