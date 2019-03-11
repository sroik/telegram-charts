//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    /*
     It's not the best decision, but I didn't
     want to use SnapKit-like in this project
     */
    func anchor(
        in view: UIView? = nil,
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topOffset: CGFloat = 0,
        leftOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0,
        rightOffset: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let view = view {
            removeFromSuperview()
            view.addSubview(self)
        }

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topOffset).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftOffset).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomOffset).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightOffset).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    func fill(in view: UIView, insets: UIEdgeInsets = .zero) {
        anchor(
            in: view,
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            topOffset: insets.top,
            leftOffset: insets.left,
            bottomOffset: insets.bottom,
            rightOffset: insets.right
        )
    }
}
