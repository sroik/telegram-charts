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
    let interactor: ChartMapInteractor
    let overlayView = ChartMapOverlayView()
    var chartView: ChartView
    let sounds: SoundService

    var viewport: Viewport {
        get {
            return overlayView.viewport
        }
        set {
            overlayView.set(viewport: newValue, animated: false)
        }
    }

    var chart: Chart {
        return chartView.chart
    }

    init(
        chartView: ChartView,
        interactor: ChartMapInteractor = ChartMapInteractor(),
        sounds: SoundService
    ) {
        self.chartView = chartView
        self.interactor = interactor
        self.sounds = sounds
        super.init(frame: .screen)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.placeholder
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        chartView.frame = bounds
        overlayView.frame = bounds
    }

    func set(viewport: Viewport, animated: Bool, duration: TimeInterval = .defaultDuration) {
        overlayView.set(viewport: viewport, animated: animated, duration: duration)
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
        interactor.minShift = chart.minViewportShift
        interactor.delegate = self
        interactor.register(in: overlayView)
    }
}

extension ChartMapView: ChartMapInteractorDelegate {
    func interactor(_ interactor: ChartMapInteractor, didChageViewportTo viewport: Viewport) {
        delegate?.mapView(self, didChageViewportTo: viewport)

        if interactor.pinnable {
            sounds.play(.haptic(event: .selection))
        }
    }

    func interactorDidLongPress(_ view: ChartMapInteractor) {
        delegate?.mapViewDidLongPress(self)
    }
}
