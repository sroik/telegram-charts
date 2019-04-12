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

    func animateColumns(from: [String], to: [String], animated: Bool) {
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
        isAnimating = true
        invalidateTimer()
    }

    private func invalidateTimer() {
        let timer = Timer(timeInterval: duration * 0.5, repeats: false) { [weak self] _ in
            self?.chartView.removeFromSuperview()
            self?.isAnimating = false
        }

        RunLoop.main.add(timer, forMode: .common)
        self.timer?.invalidate()
        self.timer = timer
    }

    private let duration = CASpringAnimation(keyPath: .bounds).settlingDuration
    private var timer: Timer?
    private var isAnimating: Bool = false
}
