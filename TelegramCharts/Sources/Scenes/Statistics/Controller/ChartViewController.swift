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
            chart: chart,
            chartView: ChartBrowserFactory.view(with: chart),
            mapView: ChartMapView(chartView: ChartViewFactory.view(with: chart))
        )
    }

    init(
        dependencies: Dependencies,
        layout: ChartViewControllerLayout,
        chart: Chart,
        chartView: ChartBrowserView,
        mapView: ChartMapView
    ) {
        self.chart = chart
        self.layout = layout
        self.chartView = chartView
        self.mapView = mapView
        self.periodView = TimePeriodView()
        self.columnsView = ColumnsListView(chart: chart, sounds: dependencies.sounds)
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

    private var chartView: ChartBrowserView
    private let periodView: TimePeriodView
    private let columnsView: ColumnsListView
    private let mapView: ChartMapView
}

extension ChartViewController: ColumnsStateViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        mapView.enable(columns: columns, animated: true)
        chartView.enable(columns: columns, animated: true)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Viewport) {
        chartView.viewport = mapView.viewport
    }
}
