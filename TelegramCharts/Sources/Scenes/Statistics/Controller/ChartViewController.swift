//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartViewController: ViewController {
    typealias Dependencies = SoundServiceContainer

    init(dependencies: Dependencies, chart: Chart) {
        self.chart = chart
        self.mapView = ChartMapView(chart: chart)
        self.chartView = ChartBrowserView(chart: chart)
        self.columnsView = ChartColumnsStackView(
            sounds: dependencies.sounds,
            columns: chart.drawableColumns
        )
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
            insets: UIEdgeInsets(top: 30, left: 15, bottom: 10, right: 15)
        )

        displayLink.start { [weak self] _ in
            self?.updateChartRange()
        }

        updateChartRange(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        chartView.theme = theme
        mapView.theme = theme
        columnsView.theme = theme
        view.backgroundColor = theme.color.placeholder
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
    private let columnsView: ChartColumnsStackView
    private let chartView: ChartBrowserView
    private let mapView: ChartMapView
    private let chart: Chart
}

extension ChartViewController: ChartColumnsStackViewDelegate {
    func columnsView(_ view: ChartColumnsStackView, didChangeEnabledColumns columns: [Column]) {
        mapView.set(range: columns.range, animated: true)
        mapView.set(enabledColumns: Set(columns), animated: true)

        chartView.set(range: viewportRange, animated: true)
        chartView.set(enabledColumns: Set(columns), animated: true)
    }
}

extension ChartViewController: ChartMapViewDelegate {
    func mapView(_ view: ChartMapOverlayView, didChageViewportTo viewport: Range<CGFloat>) {
        chartView.viewport = viewport
        displayLink.needsToDisplay = true
    }
}
