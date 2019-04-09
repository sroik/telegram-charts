//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Button: UIButton {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? highlightOpacity : 1
        }
    }

    var highlightOpacity: CGFloat = 0.75
}

extension Button {
    static func primary(
        title: String = "",
        image: UIImage? = nil,
        color: UIColor? = .white,
        font: UIFont,
        titleInsets: UIEdgeInsets = .zero,
        imageInsets: UIEdgeInsets = .zero
    ) -> Button {
        let button = Button()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.tintColor = color
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.titleLabel?.font = font
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.imageEdgeInsets = imageInsets
        button.titleEdgeInsets = titleInsets
        return button
    }
}
