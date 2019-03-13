//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapViewDelegate: ChartMapOverlayViewDelegate {}

final class ChartMapView: View {
    weak var delegate: ChartMapViewDelegate? {
        didSet {
            overlayView.delegate = delegate
        }
    }

    var range: Range<CGFloat> {
        get {
            return overlayView.range
        }
        set {
            overlayView.range = newValue
        }
    }

    var enabledColumns: Set<Column> {
        get {
            return chartLayer.enabledColumns
        }
        set {
            chartLayer.enabledColumns = newValue
        }
    }

    init(chart: Chart) {
        self.chart = chart
        self.chartLayer = ChartLayer(chart: chart)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartLayer.frame = bounds
    }

    private func setup() {
        layer.addSublayer(chartLayer)
        overlayView.fill(in: self)
    }

    private let overlayView = ChartMapOverlayView()
    private let chartLayer: ChartLayer
    private let chart: Chart
}
