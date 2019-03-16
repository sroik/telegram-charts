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

    var viewport: Range<CGFloat> {
        get {
            return overlayView.viewport
        }
        set {
            overlayView.viewport = newValue
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

    var range: Range<Int> {
        get {
            return chartLayer.range
        }
        set {
            chartLayer.range = newValue
        }
    }

    var selectedKnob: ChartMapViewportView.Knob {
        return overlayView.selectedKnob
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
        chartLayer.masksToBounds = true
        chartLayer.lineWidth = 1.0
        chartLayer.pointsThreshold = 2.0
        overlayView.fill(in: self)
    }

    private let overlayView = ChartMapOverlayView()
    private let chartLayer: ChartLayer
    private let chart: Chart
}
