//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        return !isHidden && alpha > .ulpOfOne
    }

    func fadeIn(
        animated: Bool,
        duration: TimeInterval = .defaultDuration,
        then completion: Completion? = nil
    ) {
        alpha = 0
        UIView.animate(
            withDuration: animated ? duration : 0,
            animations: { self.alpha = 1 },
            completion: { _ in completion?() }
        )
    }
}

extension UITableView {
    typealias EnumerationBlock<C> = (C) -> Void

    func forEachVisibleCell<C: UITableViewCell>(do block: EnumerationBlock<C>) {
        visibleCells
            .compactMap { $0 as? C }
            .forEach { block($0) }
    }
}

extension UILabel {
    func set(text: String?, animated: Bool, duration: TimeInterval = 0.25) {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = animated ? duration : 0
        self.text = text
        layer.add(transition, forKey: nil)
    }
}

extension UIStackView {
    var intrinsicWidth: CGFloat {
        return arrangedSubviews
            .map { $0.intrinsicContentSize.width }
            .max() ?? 0
    }
}

extension UIScrollView {
    var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: bounds.size)
    }
}
