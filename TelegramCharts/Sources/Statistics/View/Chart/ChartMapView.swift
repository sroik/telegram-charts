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

    init(chart: Chart) {
        self.chart = chart
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        columnLayers.forEach { layer in
            layer.frame = bounds
        }
    }

    private func setup() {
        let verticalRange = chart.drawableColumns.range
        chart.drawableColumns.forEach { column in
            let columnLayer = ColumnLayer(column: column)
            columnLayer.viewport = verticalRange
            layer.addSublayer(columnLayer)
            columnLayer.frame = bounds
            columnLayers.append(columnLayer)
        }

        overlayView.fill(in: self)
    }

    private let overlayView = ChartMapOverlayView()
    private var columnLayers: [ColumnLayer] = []
    private let chart: Chart
}
