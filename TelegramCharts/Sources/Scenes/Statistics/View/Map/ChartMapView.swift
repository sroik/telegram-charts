//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartMapViewDelegate: AnyObject {
    func mapView(_ view: ChartMapView, didChageViewportTo viewport: Viewport)
    func mapViewDidLongPress(_ view: ChartMapView)
}

final class ChartMapView: View {
    weak var delegate: ChartMapViewDelegate?

    var viewport: Viewport = .zeroToOne {
        didSet {
            overlayView.viewport = viewport
        }
    }

    var chart: Chart {
        return chartView.chart
    }

    init(chartView: ChartView, interactor: ChartMapInteractor = ChartMapInteractor()) {
        self.chartView = chartView
        self.interactor = interactor
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
        viewport = Range(max: 1, size: chart.preferredViewportSize)
        chartView.viewport = .zeroToOne
        chartView.layer.cornerRadius = theme.state.cornerRadius
        chartView.clipsToBounds = true
        addSubviews(chartView, overlayView)

        interactor.minSize = chart.minViewportSize
        interactor.delegate = self
        interactor.register(in: overlayView)
    }

    private let interactor: ChartMapInteractor
    private let overlayView = ChartMapOverlayView()
    private var chartView: ChartView
}

extension ChartMapView: ChartMapInteractorDelegate {
    func interactor(_ interactor: ChartMapInteractor, didChageViewportTo viewport: Viewport) {
        delegate?.mapView(self, didChageViewportTo: viewport)
    }

    func interactorDidLongPress(_ view: ChartMapInteractor) {
        delegate?.mapViewDidLongPress(self)
    }
}
