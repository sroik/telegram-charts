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
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topOffset: CGFloat = 0,
        leftOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0,
        rightOffset: CGFloat = 0,
        insets: UIEdgeInsets = .zero,
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
            let constant = topOffset + insets.top
            topAnchor.constraint(equalTo: top, constant: constant).isActive = true
        }

        if let left = left {
            let constant = leftOffset + insets.left
            leftAnchor.constraint(equalTo: left, constant: constant).isActive = true
        }

        if let bottom = bottom {
            let constant = -(bottomOffset + insets.bottom)
            bottomAnchor.constraint(equalTo: bottom, constant: constant).isActive = true
        }

        if let right = right {
            let constant = -(rightOffset + insets.right)
            rightAnchor.constraint(equalTo: right, constant: constant).isActive = true
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
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            topOffset: insets.top,
            leftOffset: insets.left,
            bottomOffset: insets.bottom,
            rightOffset: insets.right
        )
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }

    func removeFromSuperview(animated: Bool, duration: TimeInterval = 0.25) {
        UIView.animate(
            withDuration: animated ? duration : 0,
            animations: { self.alpha = 0 },
            completion: { _ in self.removeFromSuperview() }
        )
    }

    func addSubview(_ view: UIView, animated: Bool, duration: TimeInterval = 0.25) {
        view.alpha = 0
        addSubview(view)
        UIView.animate(
            withDuration: animated ? duration : 0,
            animations: { view.alpha = 1 }
        )
    }
}
