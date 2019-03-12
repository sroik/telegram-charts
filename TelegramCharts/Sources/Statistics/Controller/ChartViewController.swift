//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartViewController: ViewController {
    init(chart: Chart) {
        self.chart = chart
        self.chartView = ChartView(chart: chart)
        self.mapView = ChartMapView(chart: chart)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.anchor(
            in: view,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 44
        )

        chartView.delegate = self
        chartView.anchor(
            in: view,
            top: view.topAnchor,
            bottom: mapView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        mapView.theme = theme
        view.backgroundColor = theme.color.placeholder
    }

    private let chartView: ChartView
    private let mapView: ChartMapView
    private let chart: Chart
}

extension ChartViewController: ChartViewDelegate {}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageRange range: Range<CGFloat>) {
        print("range changed: ", range)
    }
}
