//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Rangeable {
    var range: Range<Int> { get set }
}

typealias RangeableView = UIView & Rangeable

final class ChartRangeAnimator {
    weak var view: RangeableView?

    init(view: RangeableView? = nil) {
        self.view = view
    }

    func animate(to range: Range<Int>, animated: Bool) {
        guard var view = view, range != view.range else {
            return
        }

        guard animated, let parent = view.superview, !view.bounds.isEmpty else {
            view.range = range
            return
        }

        let workspace = UIView()
        parent.addSubview(workspace)
        workspace.frame = view.frame
        workspace.clipsToBounds = true

        let snapshot = view.snapshotView
        snapshot.frame = workspace.bounds
        workspace.addSubview(snapshot)

        let rangeScale = CGFloat(view.range.max) / CGFloat(range.max)
        let translation: CGFloat = rangeScale > 1 ? 35 : -35

        view.range = range
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: translation)

        let animations = {
            snapshot.alpha = 0
            snapshot.transform = CGAffineTransform(translationX: 0, y: -translation)
            view.alpha = 1
            view.transform = .identity
        }

        UIView.animate(withDuration: .defaultDuration, animations: animations) { _ in
            workspace.removeFromSuperview()
            snapshot.removeFromSuperview()
        }
    }
}
