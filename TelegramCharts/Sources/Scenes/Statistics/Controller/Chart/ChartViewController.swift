//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate: AnyObject {
    func chartViewControllerWantsToFold(_ controller: ChartViewController)
}

class ChartViewController: ViewController {
    typealias Dependencies = SoundServiceContainer & ChartsServiceContainer

    weak var delegate: ChartViewControllerDelegate?
    let chartContainer = View()
    var layout: ChartViewControllerLayout
    var chartView: ChartBrowserView
    let columnsView: ColumnsListView
    let periodView: TimePeriodView
    let mapView: ChartMapView
    let dependencies: Dependencies
    let chart: Chart

    init(
        dependencies: Dependencies,
        layout: ChartViewControllerLayout,
        chart: Chart,
        chartView: ChartBrowserView,
        mapView: ChartMapView
    ) {
        self.chart = chart
        self.layout = layout
        self.mapView = mapView
        self.chartView = chartView
        self.dependencies = dependencies
        self.periodView = TimePeriodView(chart: chart)
        self.columnsView = ColumnsListView(chart: chart, sounds: dependencies.sounds)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        columnsView.delegate = self
        periodView.delegate = self
        chartContainer.clipsToBounds = !(chart.percentage && chart.expandable)
        set(viewport: mapView.viewport, animated: false)
        view.addSubviews(periodView, chartContainer, mapView, columnsView)
        chartContainer.addSubview(chartView)
    }

    override func didLayoutSubviewsOnBoundsChange() {
        super.didLayoutSubviewsOnBoundsChange()
        invalidateLayout()

        mapView.isHidden = !layout.hasMap
        columnsView.isHidden = !layout.hasColumns
        mapView.frame = layout.mapFrame(in: view.bounds)
        columnsView.frame = layout.columnsFrame(in: view.bounds)
        chartContainer.frame = layout.chartFrame(in: view.bounds)
        periodView.frame = layout.periodFrame(in: view.bounds)
        chartView.frame = chartContainer.bounds
    }

    override func themeUp() {
        super.themeUp()
        view.backgroundColor = theme.color.placeholder
    }

    func invalidateLayout() {
        let columnsWidth = layout.insets.inset(.screen).width
        layout.columnsHeight = columnsView.size(fitting: columnsWidth).height
    }

    func set(viewport: Viewport, animated: Bool) {
        mapView.set(viewport: viewport, animated: animated)
        periodView.viewport = viewport
        chartView.viewport = viewport
    }

    func enable(columns: [String], animated: Bool = false) {
        mapView.enable(columns: columns, animated: animated)
        chartView.enable(columns: columns, animated: animated)
        columnsView.enable(columns: columns, animated: animated)
    }
}

extension ChartViewController: ColumnsListViewDelegate, ChartMapViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        enable(columns: columns.ids, animated: true)
    }

    func mapView(_ view: ChartMapView, didChageViewportTo viewport: Viewport) {
        periodView.viewport = viewport
        chartView.viewport = viewport
    }

    func mapViewDidLongPress(_ view: ChartMapView) {
        chartView.deselect(animated: true)
    }

    func columnsViewDidLongPress(_ view: ColumnsListView) {
        chartView.deselect(animated: true)
    }
}

extension ChartViewController: TimePeriodViewDelegate {
    func periodViewWantsToFold(_ view: TimePeriodView) {
        chartView.deselect(animated: true)
        delegate?.chartViewControllerWantsToFold(self)
    }
}
