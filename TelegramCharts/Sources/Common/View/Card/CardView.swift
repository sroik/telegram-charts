//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class CardView: Control {
    let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    let itemHeight: CGFloat = 18
    let stack: UIStackView

    var items: [View] {
        didSet {
            stack.arrangedSubviews.forEach(stack.removeArrangedSubview)
            items.forEach(stack.addArrangedSubview)
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let itemsCount = stack.arrangedSubviews.filter { $0.isVisible }.count
        return CGSize(
            width: insets.horizontal + max(135, stack.maxIntrinsicWidth),
            height: insets.vertical + CGFloat(itemsCount) * itemHeight
        )
    }

    init(items: [View] = []) {
        self.items = items
        self.stack = UIStackView(arrangedSubviews: items)
        super.init(frame: .screen)
        setup()
    }

    override func layoutSubviewsOnBoundsChange() {
        super.layoutSubviewsOnBoundsChange()
        stack.frame = bounds.inset(by: insets)
    }

    override func themeUp() {
        super.themeUp()
        layer.cornerRadius = theme.state.cornerRadius
        backgroundColor = theme.color.card
        items.forEach { $0.theme = theme }
    }

    func layout(animated: Bool) {
        UIView.animate(withDuration: animated ? .fastDuration : 0) {
            self.stack.layoutIfNeeded()
        }
    }

    private func setup() {
        stack.isUserInteractionEnabled = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
    }
}
