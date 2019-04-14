//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ChartExpansionAnimator: UIViewController.LayoutAnimator {
    let duration: TimeInterval

    init(duration: TimeInterval = .smoothDuration) {
        self.duration = duration
    }

    func animate(with context: Context, then completion: @escaping Completion) {
        guard
            let parent = context.parent as? ExpandableChartViewController,
            let child = context.child as? ChartViewController
        else {
            assertionFailureWrapper("invalid types")
            completion()
            return
        }

        guard context.animated else {
            completion()
            return
        }

        child.view.setNeedsLayout()
        child.view.layoutIfNeeded()
        child.view.backgroundColor = .clear

        toggledFade(child.periodView, child.columnsView, to: context.presenting ? 1 : 0)
        animateMap(child: child, parent: parent, presenting: context.presenting)
        animateChart(child: child, parent: parent, presenting: context.presenting) {
            if context.presenting {
                child.view.backgroundColor = parent.view.backgroundColor
            }

            completion()
        }
    }

    func animateChart(
        child: ChartViewController,
        parent: ChartViewController,
        presenting: Bool,
        then completion: @escaping Completion
    ) {
        let timelineBrowser = child.chartView as? TimelineChartBrowserView
        let timeBrowserClipping = timelineBrowser?.chartContainer.clipsToBounds ?? true
        timelineBrowser?.chartContainer.clipsToBounds = false

        let upscale = CGAffineTransform(scaleX: 5, y: 1)
        let downscale = CGAffineTransform(scaleX: 0.25, y: 1)

        parent.chartView.transform = presenting ? .identity : upscale
        parent.chartView.alpha = presenting ? 1 : 0
        child.chartView.transform = presenting ? downscale : .identity
        child.chartView.alpha = presenting ? 0 : 1

        let animation = {
            parent.chartView.transform = presenting ? upscale : .identity
            parent.chartView.alpha = presenting ? 0 : 1
            child.chartView.transform = presenting ? .identity : downscale
            child.chartView.alpha = presenting ? 1 : 0
        }

        run(animation: animation) {
            timelineBrowser?.chartContainer.clipsToBounds = timeBrowserClipping
            completion()
        }
    }

    func toggledFade(_ views: UIView..., to: CGFloat) {
        let from: CGFloat = (to < .ulpOfOne) ? 1 : 0
        fade(views, from: from, to: to)
    }

    func fade(_ views: [UIView], from: CGFloat, to: CGFloat) {
        views.forEach { $0.alpha = from }
        run(animation: {
            views.forEach { $0.alpha = to }
        })
    }

    func animateMap(
        child: ChartViewController,
        parent: ChartViewController,
        presenting: Bool
    ) {
        guard child.layout.hasMap, parent.layout.hasMap else {
            toggledFade(parent.mapView, to: presenting ? 0 : 1)
            return
        }

        let from = presenting ? parent : child
        let to = presenting ? child : parent
        let fromViewport = from.mapView.viewport
        let toViewport = to.mapView.viewport

        to.mapView.set(viewport: fromViewport, animated: false)
        to.mapView.set(viewport: toViewport, animated: true, duration: duration)
        from.mapView.set(viewport: toViewport, animated: true, duration: duration)
        child.mapView.alpha = presenting ? 0 : 1

        let animation = {
            child.mapView.alpha = presenting ? 1 : 0
        }

        run(animation: animation) {
            from.mapView.set(viewport: fromViewport, animated: false)
        }
    }

    func run(
        animation: @escaping () -> Void,
        options: UIView.AnimationOptions = .curveEaseInOut,
        then completion: Completion? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
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
