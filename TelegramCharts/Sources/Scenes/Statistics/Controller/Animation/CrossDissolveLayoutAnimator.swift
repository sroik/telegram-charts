//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class CrossDissolveLayoutAnimator: UIViewController.LayoutAnimator {
    let duration: TimeInterval

    init(duration: TimeInterval = .smoothDuration) {
        self.duration = duration
    }

    func animate(
        with context: UIViewController.LayoutAnimator.Context,
        completion: @escaping UIViewController.LayoutAnimator.Completion
    ) {
        let animations = {
            context.child.view.alpha = context.presenting ? 1 : 0
        }

        context.child.view.alpha = context.presenting ? 0 : 1
        UIView.animate(withDuration: duration, animations: animations) { _ in
            completion()
        }
    }
}
