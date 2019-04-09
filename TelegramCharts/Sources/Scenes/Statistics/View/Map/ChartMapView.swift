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

    convenience init(chart: Chart) {
        self.init(chartView: ChartView(chart: chart))
    }

    init(chartView: ChartView) {
        self.chartView = chartView
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
        overlayView.frame = bounds
    }

    func set(enabledColumns columns: Set<Column>, animated: Bool = false) {
        chartView.set(enabledColumns: columns, animated: animated)
    }

    private func setup() {
        addSubview(chartView)
        chartView.viewport = .zeroToOne
        chartView.layer.cornerRadius = 6
        chartView.clipsToBounds = true
        chartView.set(lineWidth: 1)
        addSubviews(overlayView)
    }

    private let overlayView = ChartMapOverlayView()
    private let chartView: ChartView
}
