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
        chartView.delegate = self
        periodView.delegate = self
        chartView.viewport = mapView.viewport
        view.addSubviews(periodView, mapView, chartView, columnsView)
    }

    override func didLayoutSubviewsOnBoundsChange() {
        super.didLayoutSubviewsOnBoundsChange()
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

    func expand(at index: Int, in viewport: Viewport) {
        guard let chart = dependencies.charts.expanded(chart: chart, at: index) else {
            assertionFailureWrapper("failed to expand chart", self.chart.title)
            return
        }

        let controller = ChartViewControllerFactory.controller(
            with: chart,
            dependencies: dependencies
        )

        controller.delegate = self
        controller.theme = theme
        add(child: controller)
    }

    override func themeUp() {
        super.themeUp()
        view.backgroundColor = theme.color.placeholder
    }
}

extension ChartViewController: ChartViewControllerDelegate {
    func chartViewControllerWantsToFold(_ controller: ChartViewController) {
        controller.dropFromParent()
    }
}

extension ChartViewController: ColumnsListViewDelegate, ChartMapViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        mapView.enable(columns: columns, animated: true)
        chartView.enable(columns: columns, animated: true)
    }

    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Viewport) {
        periodView.viewport = mapView.viewport
        chartView.viewport = mapView.viewport
    }

    func mapViewDidLongPress(_ view: ChartMapOverlayView) {
        chartView.deselect(animated: true)
    }

    func columnsViewDidLongPress(_ view: ColumnsListView) {
        chartView.deselect(animated: true)
    }
}

extension ChartViewController: ChartBrowserDelegate, TimePeriodViewDelegate {
    func chartBrowser(_ view: ChartBrowserView, wantsToExpand index: Int) {
        expand(at: index, in: mapView.viewport)
    }

    func periodViewWantsToFold(_ view: TimePeriodView) {
        delegate?.chartViewControllerWantsToFold(self)
    }
}
