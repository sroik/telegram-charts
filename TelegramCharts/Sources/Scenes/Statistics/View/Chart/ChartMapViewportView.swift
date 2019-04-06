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

    let knobWidth: CGFloat = 10
    let lineWidth: CGFloat = 1.5
    let tapAreaInsets: UIEdgeInsets = UIEdgeInsets(repeated: -15)
    var selectedKnob: Knob = .none

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
        let knobsFrame = bounds.inset(by: UIEdgeInsets(top: lineWidth, bottom: lineWidth))
        leftKnob.frame = knobsFrame.slice(at: knobWidth, from: .minXEdge)
        rightKnob.frame = knobsFrame.slice(at: knobWidth, from: .maxXEdge)
        bottomLine.frame = bounds.slice(at: lineWidth, from: .maxYEdge)
        topLine.frame = bounds.slice(at: lineWidth, from: .minYEdge)
    }

    private func setup() {
        layer.cornerRadius = lineWidth
        layer.masksToBounds = true

        rightKnob.contentMode = .center
        leftKnob.contentMode = .center
        addSubviews(topLine, bottomLine, rightKnob, leftKnob)
    }

    override func themeUp() {
        super.themeUp()
        [leftKnob, rightKnob, topLine, bottomLine].forEach { view in
            view.backgroundColor = theme.color.control.withAlphaComponent(0.75)
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
