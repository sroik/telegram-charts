//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartViewController: ViewController {
    init(chart: Chart) {
        self.chart = chart
        self.mapView = ChartMapView(chart: chart)
        self.chartView = ChartView(chart: chart)
        self.columnsView = ChartColumnsStackView(columns: chart.drawableColumns)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        columnsView.delegate = self
        columnsView.anchor(
            in: view,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 44 * CGFloat(chart.drawableColumns.count)
        )

        mapView.viewport = chartView.viewport
        mapView.delegate = self
        mapView.anchor(
            in: view,
            bottom: columnsView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            insets: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15),
            height: 42
        )

        chartView.anchor(
            in: view,
            top: view.topAnchor,
            bottom: mapView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            insets: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        )
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        mapView.theme = theme
        columnsView.theme = theme
        view.backgroundColor = theme.color.placeholder
    }

    private let columnsView: ChartColumnsStackView
    private let chartView: ChartView
    private let mapView: ChartMapView
    private let chart: Chart
}

extension ChartViewController: ChartColumnsStackViewDelegate {
    func columnsView(_ view: ChartColumnsStackView, didChangeEnabledColumns columns: [Column]) {
        mapView.enabledColumns = Set(columns)
        chartView.enabledColumns = Set(columns)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Range<CGFloat>) {
        chartView.viewport = viewport
    }
}
