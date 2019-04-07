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

    let tapAreaInsets: UIEdgeInsets = UIEdgeInsets(repeated: -15)
    var selectedKnob: Knob = .none

    var knobWidth: CGFloat {
        return 10 + 2 * theme.knobBorderWidth
    }

    var lineWidth: CGFloat {
        return 1 + theme.knobBorderWidth
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func knob(at point: CGPoint) -> Knob {
        guard tapAreaInsets.inset(bounds).contains(point) else {
            return .none
        }

        if bounds.width < 75, midFrame.contains(point) {
            return .mid
        }

        if point.x < leftKnob.frame.maxX {
            return .left
        }

        if point.x > rightKnob.frame.minX {
            return .right
        }

        if leftKnob.frame.inset(by: tapAreaInsets).contains(point) {
            return .left
        }

        if rightKnob.frame.inset(by: tapAreaInsets).contains(point) {
            return .right
        }

        return .mid
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftKnob.frame = bounds.slice(at: knobWidth, from: .minXEdge)
        rightKnob.frame = bounds.slice(at: knobWidth, from: .maxXEdge)
        bottomLine.frame = bounds.slice(at: lineWidth, from: .maxYEdge)
        topLine.frame = bounds.slice(at: lineWidth, from: .minYEdge)
    }

    private func setup() {
        layer.cornerRadius = 6
        layer.masksToBounds = true

        [leftKnob, rightKnob].forEach { view in
            view.contentMode = .center
        }

        addSubviews(rightKnob, leftKnob, topLine, bottomLine)
    }

    override func themeUp() {
        super.themeUp()
        setNeedsLayout()

        [leftKnob, rightKnob, self].forEach { view in
            view.layer.borderColor = theme.knobBorder.cgColor
            view.layer.borderWidth = theme.knobBorderWidth
        }

        [leftKnob, rightKnob, topLine, bottomLine].forEach { view in
            view.backgroundColor = theme.knob
        }
    }

    private var midFrame: CGRect {
        return CGRect(
            x: leftKnob.frame.maxX,
            y: 0,
            width: rightKnob.frame.minX - leftKnob.frame.maxX,
            height: bounds.height
        )
    }

    private let leftKnob = UIImageView(image: Image.leftKnobArrow)
    private let rightKnob = UIImageView(image: Image.rightKnobArrow)
    private let topLine = UIView()
    private let bottomLine = UIView()
}

extension ChartMapViewportView.Knob {
    var isSide: Bool {
        switch self {
        case .left, .right: return true
        case .mid, .none: return false
        }
    }
}

private extension Theme {
    var knobBorderWidth: CGFloat {
        switch self {
        case .day: return 1
        case .night: return 0
        }
    }

    var knobBorder: UIColor {
        switch self {
        case .day: return .white
        case .night: return .clear
        }
    }

    var knob: UIColor {
        switch self {
        case .day: return UIColor(red: 192 / 255, green: 209 / 255, blue: 225 / 255, alpha: 1)
        case .night: return UIColor(red: 86 / 255, green: 98 / 255, blue: 109 / 255, alpha: 1)
        }
    }
}
