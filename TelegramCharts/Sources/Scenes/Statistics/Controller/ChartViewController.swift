//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartViewController: ViewController {
    typealias Dependencies = SoundServiceContainer

    var layout: ChartViewControllerLayout
    let chart: Chart

    convenience init(dependencies: Dependencies, chart: Chart) {
        self.init(
            dependencies: dependencies,
            layout: ChartViewControllerLayout(chart: chart),
            chart: chart
        )
    }

    init(
        dependencies: Dependencies,
        layout: ChartViewControllerLayout,
        chart: Chart
    ) {
        self.chart = chart
        self.layout = layout
        self.mapView = ChartMapView(chart: chart)
        self.chartView = ChartBrowserView(chart: chart)
        self.periodView = TimePeriodView()
        self.columnsView = ColumnsListView(
            columns: chart.drawableColumns,
            sounds: dependencies.sounds
        )
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        columnsView.delegate = self
        chartView.viewport = mapView.viewport
        view.addSubviews(periodView, mapView, chartView, columnsView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        invalidateLayout()

        mapView.isHidden = !layout.hasMap
        columnsView.isHidden = !layout.hasColumns
        mapView.frame = layout.mapFrame(in: view.bounds)
        columnsView.frame = layout.columnsFrame(in: view.bounds)
        chartView.frame = layout.chartFrame(in: view.bounds)
        periodView.frame = layout.periodFrame(in: view.bounds)
    }

    func invalidateLayout() {
        layout.columnsHeight = columnsView.size(fitting: CGRect.screen.width).height
    }

    override func themeUp() {
        super.themeUp()
        view.backgroundColor = theme.color.placeholder
    }

    private let periodView: TimePeriodView
    private let columnsView: ColumnsListView
    private let chartView: ChartBrowserView
    private let mapView: ChartMapView
}

extension ChartViewController: ColumnsStateViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        mapView.set(enabledColumns: Set(columns), animated: true)
        chartView.set(enabledColumns: Set(columns), animated: true)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Viewport) {
        chartView.viewport = mapView.viewport
    }
}
