//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct UIViewControllerLayoutContext {
    public let parent: UIViewController
    public let child: UIViewController
    public let animated: Bool
    public let presenting: Bool
}

protocol UIViewControllerLayoutAnimator {
    typealias Completion = () -> Void
    typealias Context = UIViewControllerLayoutContext
    func animate(with context: Context, completion: @escaping Completion)
}

extension UIViewController {
    typealias LayoutCallback = (UIViewController, UIViewController) -> Void
    typealias LayoutAnimator = UIViewControllerLayoutAnimator

    func add(child: UIViewController) {
        child.willMove(toParent: self)
        view.addSubview(child.view)
        child.view.frame = view.bounds
        addChild(child)
        child.didMove(toParent: self)
    }

    func dropFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
        didMove(toParent: nil)
    }

    func add(
        child: UIViewController,
        withAnimator animator: LayoutAnimator,
        animated: Bool = true,
        completion: LayoutAnimator.Completion? = nil
    ) {
        add(child: child)

        let ctx = UIViewControllerLayoutContext(
            parent: self,
            child: child,
            animated: animated,
            presenting: true
        )

        animator.animate(with: ctx) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func dropFromParent(
        withAnimator animator: LayoutAnimator,
        animated: Bool = true,
        completion: LayoutAnimator.Completion? = nil
    ) {
        guard let parent = self.parent else {
            completion?()
            return
        }

        let ctx = UIViewControllerLayoutContext(
            parent: parent,
            child: self,
            animated: animated,
            presenting: false
        )

        animator.animate(with: ctx) {
            DispatchQueue.main.async {
                self.dropFromParent()
                completion?()
            }
        }
    }
}
