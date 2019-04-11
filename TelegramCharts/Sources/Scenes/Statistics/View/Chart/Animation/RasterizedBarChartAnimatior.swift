//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class RasterizedBarChartAnimator {
    weak var target: RasterizedBarChartView?
    let duration: TimeInterval = .smoothDuration
    let chartView: BarChartView

    init(target: RasterizedBarChartView) {
        self.target = target
        self.chartView = BarChartView(chart: target.chart)
    }

    func animateColumns(from: [Column], to: [Column], animated: Bool) {
        guard animated, let target = target, target.minViewportSize < 1 else {
            return
        }

        target.addSubview(chartView)
        target.bringSubviewToFront(target.overlayView)

        chartView.alpha = 1
        chartView.theme = target.theme
        chartView.frame = target.bounds
        chartView.layoutIfNeeded()
        chartView.viewport = target.viewport
        chartView.enable(columns: from, animated: false)
        chartView.enable(columns: to, animated: true)
        invalidateTimer()
    }

    private func invalidateTimer() {
        let timer = Timer(timeInterval: duration, repeats: false) { [weak self] _ in
            self?.chartView.removeFromSuperview(animated: true)
        }

        RunLoop.main.add(timer, forMode: .common)
        self.timer?.invalidate()
        self.timer = timer
    }

    private var timer: Timer?
}
