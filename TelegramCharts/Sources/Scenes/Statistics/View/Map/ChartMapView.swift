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

    var viewport: Viewport {
        get {
            return overlayView.viewport
        }
        set {
            overlayView.viewport = newValue
        }
    }

    var selectedKnob: ChartMapViewportView.Knob {
        return overlayView.selectedKnob
    }

    var chart: Chart {
        return chartView.chart
    }

    init(chartView: ChartView) {
        self.chartView = chartView
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartView.frame = bounds
        overlayView.frame = bounds
    }

    func enable(columns: [String], animated: Bool = false) {
        chartView.enable(columns: columns, animated: animated)
    }

    private func setup() {
        chartView.viewport = .zeroToOne
        chartView.layer.cornerRadius = theme.state.cornerRadius
        chartView.clipsToBounds = true
        addSubview(chartView)

        overlayView.minSize = chart.minViewportSize
        overlayView.viewport = Range(max: 1, size: chart.preferredViewportSize)
        addSubviews(overlayView)
    }

    private let overlayView = ChartMapOverlayView()
    private var chartView: ChartView
}
