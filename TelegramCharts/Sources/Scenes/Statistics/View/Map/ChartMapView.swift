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

    init(chartView: LineChartView) {
        self.chartView = chartView
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
        overlayView.frame = bounds
    }

    func enable(columns: [Column], animated: Bool = false) {
        chartView.enable(columns: columns, animated: animated)
    }

    private func setup() {
        addSubview(chartView)
        chartView.viewport = .zeroToOne
        chartView.layer.cornerRadius = 6
        chartView.clipsToBounds = true
        addSubviews(overlayView)
    }

    private let overlayView = ChartMapOverlayView()
    private let chartView: LineChartView
}
