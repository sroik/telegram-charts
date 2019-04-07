//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class CardView: View {
    let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    let itemHeight: CGFloat = 15
    let items: [View]
    let stack: UIStackView

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: insets.horizontal + max(130, stack.maxIntrinsicWidth),
            height: insets.vertical + CGFloat(items.count) * itemHeight
        )
    }

    init(items: [View]) {
        self.items = items
        self.stack = UIStackView(arrangedSubviews: items)
        super.init(frame: .screen)
        setup()
    }

    override func themeUp() {
        super.themeUp()
        backgroundColor = theme.color.popup
        items.forEach { $0.theme = theme }
        stack.frame = bounds.inset(by: insets)
    }

    private func setup() {
        isUserInteractionEnabled = false
        layer.cornerRadius = 6

        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
    }
}
