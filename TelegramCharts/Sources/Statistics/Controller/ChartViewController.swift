//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartViewController: ViewController {
    init(chart: Chart) {
        self.chart = chart
        self.chartView = ChartView(chart: chart)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.fill(in: view)
        chartView.delegate = self
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        view.backgroundColor = theme.color.placeholder
    }

    private let chartView: ChartView
    private let chart: Chart
}

extension ChartViewController: ChartViewDelegate {}
