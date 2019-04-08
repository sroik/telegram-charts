//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartViewController: ViewController {
    typealias Dependencies = SoundServiceContainer

    var columnsViewSize: CGSize {
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

        if hasColumnsList {
            columnsView.delegate = self
            columnsView.anchor(
                in: view,
                bottom: view.bottomAnchor,
                left: view.leftAnchor,
                right: view.rightAnchor,
                height: columnsViewSize.height
            )
        }

        mapView.delegate = self
        mapView.anchor(
            in: view,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            bottomOffset: columnsViewSize.height,
            insets: UIEdgeInsets(right: 15, bottom: 15, left: 15),
            height: 40
        )

        chartView.clipsToBounds = true
        chartView.anchor(
            in: view,
            top: view.topAnchor,
            bottom: mapView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            insets: UIEdgeInsets(top: 30, bottom: 10)
        )

        displayLink.start { [weak self] _ in
            self?.updateChartRange()
        }

        updateChartViewport()
        updateChartRange(animated: false)
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
        displayLink.needsToDisplay = true
    }

    private func updateChartRange(animated: Bool = true) {
        chartView.set(range: viewportRange, animated: animated)
    }

    private var viewportRange: Range<Int> {
        /* let's scale range a little to make it look better */
        return columnsView.enabledColumns
            .range(in: mapView.viewport)
            .scaled(by: 1.1, from: .center)
            .clamped(from: 0, to: .max)
    }

    private let displayLink = DisplayLink(fps: 2)
    private let columnsView: ColumnsListView
    private let chartView: ChartBrowserView
    private let mapView: ChartMapView
    private let chart: Chart
}

extension ChartViewController: ColumnsStateViewDelegate {
    func columnsView(_ view: ColumnsListView, didEnable columns: [Column]) {
        mapView.set(range: columns.range, animated: true)
        mapView.set(enabledColumns: Set(columns), animated: true)

        chartView.set(range: viewportRange, animated: true)
        chartView.set(enabledColumns: Set(columns), animated: true)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Range<CGFloat>) {
        updateChartViewport()
    }
}
