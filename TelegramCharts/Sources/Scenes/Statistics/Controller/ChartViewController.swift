//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartViewController: ViewController {
    typealias Dependencies = SoundServiceContainer

    var columnsListSize: CGSize {
        return hasColumnsList ? columnsView.size(fitting: CGRect.screen.width) : .zero
    }

    var hasColumnsList: Bool {
        return chart.drawableColumns.count > 1
    }

    init(dependencies: Dependencies, chart: Chart) {
        self.chart = chart
        self.mapView = ChartMapView(chart: chart)
        self.chartView = ChartBrowserView(chart: chart)
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
        chartView.clipsToBounds = true
        chartView.viewport = mapView.viewport

        view.addSubviews(periodView, mapView, chartView, columnsView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let columnsHeight = columnsListSize.height
        columnsView.isHidden = !hasColumnsList
        columnsView.frame = view.bounds.slice(at: columnsListSize.height, from: .maxYEdge)

        let mapInsets = UIEdgeInsets(right: 15, bottom: columnsHeight + 15, left: 15)
        mapView.frame = mapInsets.inset(view.bounds).slice(at: 40, from: .maxYEdge)

        let periodInsets = UIEdgeInsets(right: 15, left: 15)
        periodView.frame = periodInsets.inset(view.bounds).slice(at: 32, from: .minYEdge)

        chartView.frame = CGRect(
            x: 0,
            y: periodView.frame.maxY,
            width: view.bounds.width,
            height: mapView.frame.minY - periodView.frame.maxY - 10
        )
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        mapView.theme = theme
        columnsView.theme = theme
        view.backgroundColor = theme.color.placeholder
    }

    private func updateChartViewport() {
        chartView.viewport = mapView.viewport
    }

    private let periodView = TimePeriodView()
    private let columnsView: ColumnsListView
    private let chartView: ChartBrowserView
    private let mapView: ChartMapView
    private let chart: Chart
}

extension ChartViewController: ColumnsStateViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        mapView.set(enabledColumns: Set(columns), animated: true)
        chartView.set(enabledColumns: Set(columns), animated: true)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Viewport) {
        updateChartViewport()
    }
}
