//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class LineColumnLayer: Layer {
    var lineWidth: CGFloat = 2 {
        didSet {
            shapeLayer.lineWidth = lineWidth
            pointLayer.lineWidth = lineWidth
        }
    }

    var selectedIndex: Int? {
        didSet {
            drawSelectedPoint()
        }
    }

    let column: Column

    init(column: Column) {
        self.column = column
        super.init()
        setup()
    }

    override init(layer: Any) {
        column = .empty
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(column: .empty)
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        shapeLayer.frame = contentFrame
        pointLayer.frame = contentFrame
        draw(animated: false)
    }

    override func themeUp() {
        super.themeUp()
        pointLayer.fillColor = theme.color.placeholder.cgColor
    }

    func set(pointsThreshold: CGFloat, animated: Bool) {
        if self.pointsThreshold != pointsThreshold {
            self.pointsThreshold = pointsThreshold
            draw(animated: animated)
        }
    }

    func set(range: Range<Int>, animated: Bool) {
        if self.range != range {
            self.range = range
            draw(animated: animated)
        }
    }

    func draw(animated: Bool) {
        switch column.type {
        case .line:
            drawLineColumn(animated: animated)
            drawSelectedPoint(animated: animated)
        default:
            assertionFailureWrapper("column type is not supported")
        }
    }

    private func drawLineColumn(animated: Bool) {
        let points = column.points(in: shapeLayer.bounds, range: range)
        let filteredPoint = points.dropClose(threshold: pointsThreshold)
        let path = CGPath.between(points: filteredPoint)
        shapeLayer.update(path: path, animated: animated)
    }

    private func drawSelectedPoint(animated: Bool = false) {
        guard let index = selectedIndex else {
            pointLayer.path = nil
            return
        }

        let point = column.point(at: index, in: pointLayer.bounds, range: range)
        let path = CGPath.circle(center: point, radius: lineWidth * 1.5)
        pointLayer.update(path: path, animated: animated)
    }

    private func setup() {
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = column.cgColor
        pointLayer.strokeColor = column.cgColor
        pointLayer.lineWidth = lineWidth
        addSublayer(shapeLayer)
        addSublayer(pointLayer)
    }

    private var contentFrame: CGRect {
        return contentInsets.inset(bounds)
    }

    private var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: lineWidth * 2, bottom: lineWidth * 2)
    }

    private var pointsThreshold: CGFloat = .pointsEpsilon
    private var range: Range<Int> = .zero
    private let pointLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
}
