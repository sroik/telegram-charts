//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class RasterizedBarChartAnimator {
    weak var target: RasterizedBarChartView?
    let chartView: BarChartView

    init(target: RasterizedBarChartView) {
        self.target = target
        self.chartView = BarChartView(chart: target.chart)
    }

    @discardableResult
    func animateColumns(from: [String], to: [String], animated: Bool) -> Bool {
        guard animated, let target = target, target.minViewportSize < 1 else {
            return false
        }

        chartView.frame = target.bounds
        chartView.viewport = target.viewport

        guard isSupported() else {
            return false
        }

        target.addSubview(chartView)
        target.bringSubviewToFront(target.overlayView)

        chartView.theme = target.theme
        chartView.layoutIfNeeded()
        chartView.enable(columns: from, animated: false)
        chartView.enable(columns: to, animated: true)
        invalidateTimer()
        return true
    }

    private func isSupported() -> Bool {
        let supportedLayersNumber = Device.isFast ? 365 : 125
        let visibleLayersNumber = chartView.visibleLayersNumber()
        return visibleLayersNumber <= supportedLayersNumber
    }

    private func invalidateTimer() {
        let timer = Timer(timeInterval: duration, repeats: false) { [weak self] _ in
            self?.chartView.removeFromSuperview()
        }

        RunLoop.main.add(timer, forMode: .common)
        self.timer?.invalidate()
        self.timer = timer
    }

    private let duration: TimeInterval = .smoothDuration
    private var timer: Timer?
}
