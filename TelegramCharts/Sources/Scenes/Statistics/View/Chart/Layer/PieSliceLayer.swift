//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class PieSliceLayer: Layer {
    let id: String
    let color: CGColor?
    var isSelected: Bool = false

    var visualPath: CGPath {
        return CGPath.circleSlice(
            center: center,
            radius: radius,
            startAngle: startAngle + slice.min,
            endAngle: startAngle + slice.max
        )
    }

    var radius: CGFloat {
        return bounds.minSide / 2
    }

    var center: CGPoint {
        return bounds.center
    }

    init(value: StackedColumnValue) {
        id = value.id
        color = value.color
        super.init()
        setup()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(value: StackedColumnValue(id: "", value: 0))
    }

    override init(layer: Any) {
        id = ""
        color = nil
        super.init(layer: layer)
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        arcLayer.frame = bounds
        arcLayer.path = circlePath
        arcLayer.lineWidth = radius
        draw(animated: false)
    }

    func set(percent: CGFloat, slice: PieSlice, animated: Bool) {
        self.slice = slice
        self.percent = percent
        draw(animated: animated)
    }

    func draw(animated: Bool) {
        arcLayer.spring(to: slice.relative(), animated: animated)
        arcLayer.spring(to: stateTransform, for: .transform, animated: animated)

        percentLayer.string = percentString
        percentLayer.spring(to: percentFontSize, for: .fontSize, animated: animated)
        percentLayer.spring(to: percentFrame, animated: animated)
        percentLayer.set(value: isSliceSmall ? 0 : 1, for: .opacity, animated: animated)
    }

    private func setup() {
        addSublayer(arcLayer)
        arcLayer.addSublayer(percentLayer)
        arcLayer.fillColor = nil
        arcLayer.strokeColor = color
        arcLayer.disableActions()
        disableActions()
    }

    private func centerPoint(radius: CGFloat) -> CGPoint {
        let x = center.x + cos(centerAngle) * radius
        let y = center.y + sin(centerAngle) * radius
        return CGPoint(x: x, y: y)
    }

    private var isSliceFullCircle: Bool {
        return abs(slice.size - 2 * .pi) < .ulpOfOne
    }

    private var isSliceSmall: Bool {
        return slice.size < .pi / 30
    }

    private var stateTransform: CATransform3D {
        let shift = (isSelected && !isSliceFullCircle) ? selectedShift : 0
        let offset = centerPoint(radius: shift) - center
        return CATransform3DMakeTranslation(offset.x, offset.y, 0)
    }

    private var percentFontSize: CGFloat {
        let maxSize: CGFloat = 30
        let minSize: CGFloat = 8
        return (maxSize * minMaxSliceProgress).clamped(from: minSize, to: maxSize)
    }

    private var minMaxSliceProgress: CGFloat {
        let angle = slice.size
        let maxAngle = CGFloat.pi / 2
        let ratio = (angle / maxAngle)
        return ratio.clamped(from: 0, to: 1)
    }

    private var percentFrame: CGRect {
        return CGRect(
            center: isSliceFullCircle ? center : percentCenter,
            size: percentSize
        )
    }

    private var percentCenter: CGPoint {
        let radiusRatio = 1 - (minMaxSliceProgress * 0.5)
        let distance = radius * radiusRatio.clamped(from: 0.5, to: 0.85)
        return centerPoint(radius: distance)
    }

    private var percentSize: CGSize {
        return percentLayer.preferredFrameSize()
    }

    private var percentString: String {
        return String(percent: percent)
    }

    private var centerAngle: CGFloat {
        return startAngle + slice.mid
    }

    private var circlePath: CGPath {
        return CGPath.circle(
            center: center,
            radius: radius / 2,
            startAngle: startAngle
        )
    }

    /* let's rotate a path little to make it pretty */
    private let startAngle: CGFloat = -CGFloat.pi / 9
    private let selectedShift: CGFloat = 10

    private let arcLayer = CAShapeLayer()
    private let percentLayer = CATextLayer.pieSlice()
    private(set) var percent: CGFloat = 0
    private(set) var slice: PieSlice = .zero
}

private extension CATextLayer {
    static func pieSlice() -> CATextLayer {
        let layer = ActionlessTextLayer()
        layer.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        layer.foregroundColor = UIColor.white.cgColor
        layer.contentsScale = Device.scale
        return layer
    }
}

private extension Range where T == CGFloat {
    func relative() -> Range {
        return Range(
            min: min / (2 * .pi),
            max: max / (2 * .pi)
        )
    }
}
