//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class PieChartExpansionAnimator: ChartExpansionAnimator {
    override func animateChart(
        child: ChartViewController,
        parent: ChartViewController,
        presenting: Bool,
        then completion: @escaping ChartExpansionAnimator.Completion
    ) {
        let fromChart = parent.chartView
        let pieChart = child.chartView

        let rotation = CGAffineTransform(rotationAngle: .pi / 4)
        let upscale = CGAffineTransform(scaleX: 1.6, y: 1.6)
        let downscale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let transform = upscale.concatenating(rotation)
        let cornerRadius = fromChart.bounds.maxSide * 0.6

        fromChart.layer.masksToBounds = true
        fromChart.alpha = presenting ? 1 : 0.5
        fromChart.transform = presenting ? .identity : downscale
        pieChart.alpha = presenting ? 0.5 : 1
        pieChart.transform = CGAffineTransform(scaleX: 2, y: 2)
        pieChart.transform = presenting ? transform : .identity

        let animation = {
            fromChart.transform = presenting ? downscale : .identity
            fromChart.layer.cornerRadius = presenting ? cornerRadius : 0
            fromChart.alpha = presenting ? 0 : 1
            pieChart.alpha = presenting ? 1 : 0
            pieChart.transform = presenting ? .identity : transform
        }

        spring(animation: animation, duration: 1.75 * duration) {
            fromChart.layer.masksToBounds = false
            completion()
        }
    }

    private func spring(
        animation: @escaping () -> Void,
        duration: TimeInterval,
        options: UIView.AnimationOptions = .curveEaseInOut,
        then completion: Completion? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: options,
            animations: animation,
            completion: { isFinished in
                if isFinished {
                    completion?()
                }
            }
        )
    }
}
