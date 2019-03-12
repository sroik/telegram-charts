//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartMapViewportView: View {
    enum Knob: String {
        case none
        case left
        case right
        case mid
    }

    let lineWidth: CGFloat = 1.5
    let tapAreaInsets: UIEdgeInsets = UIEdgeInsets(repeated: -15)
    var selectedKnob: Knob = .none

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    func knob(at point: CGPoint) -> Knob {
        guard tapAreaInsets.inset(frame).contains(point) else {
            return .none
        }

        if point.x < leftKnob.frame.maxX + frame.origin.x {
            return .left
        }

        if point.x > rightKnob.frame.minX + frame.origin.x {
            return .right
        }

        return .mid
    }

    private func layout() {
        layer.cornerRadius = 1
        layer.masksToBounds = true

        leftKnob.anchor(
            in: self,
            top: topAnchor,
            bottom: bottomAnchor,
            left: leftAnchor,
            width: 8
        )

        rightKnob.anchor(
            in: self,
            top: topAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            width: 8
        )

        topLine.anchor(
            in: self,
            top: topAnchor,
            left: leftKnob.rightAnchor,
            right: rightKnob.leftAnchor,
            height: lineWidth
        )

        bottomLine.anchor(
            in: self,
            bottom: bottomAnchor,
            left: leftKnob.rightAnchor,
            right: rightKnob.leftAnchor,
            height: lineWidth
        )
    }

    override func themeUp() {
        super.themeUp()
        [leftKnob, rightKnob, topLine, bottomLine].forEach { view in
            view.backgroundColor = theme.color.control.withAlphaComponent(0.75)
        }
    }

    private let leftKnob = UIView()
    private let rightKnob = UIView()
    private let topLine = UIView()
    private let bottomLine = UIView()
}
