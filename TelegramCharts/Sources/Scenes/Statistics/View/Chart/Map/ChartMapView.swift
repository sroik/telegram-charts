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

    var selectedKnob: ChartMapViewportView.Knob {
        return overlayView.selectedKnob
    }

    init(chart: Chart) {
        self.chart = chart
        self.chartView = ChartView(chart: chart)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
        overlayView.frame = bounds
    }

    func set(range: Range<Int>, animated: Bool = false) {
        chartView.set(range: range, animated: animated)
    }

    func set(enabledColumns: Set<Column>, animated: Bool = false) {
        chartView.set(enabledColumns: enabledColumns, animated: animated)
    }

    private func setup() {
        addSubview(chartView)
        chartView.layer.cornerRadius = 6
        chartView.clipsToBounds = true
        chartView.set(lineWidth: 1)
        chartView.set(pointsThreshold: 2)
        addSubviews(overlayView)
    }

    private let overlayView = ChartMapOverlayView()
    private let chartView: ChartView
    private let chart: Chart
}
