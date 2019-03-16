//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ColumnLayer: Layer {
    var lineWidth: CGFloat = 2 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }

    let column: Column?

    init(column: Column?) {
        self.column = column
        super.init()
        setup()
    }

    override init(layer: Any) {
        column = nil
        super.init(layer: layer)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(column: nil)
    }

    override func layoutSublayersOnBoundsChange() {
        super.layoutSublayersOnBoundsChange()
        shapeLayer.frame = contentInsets.inset(bounds)
        draw(animated: false)
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
        guard let column = column else {
            return
        }

        switch column.type {
        case .line:
            drawLineColumn(column, animated: animated)
        default:
            assertionFailureWrapper("column type is not supported yet")
        }
    }

    private func drawLineColumn(_ column: Column, animated: Bool) {
        let points = column.points(in: shapeLayer.bounds, range: range)
        let filteredPoint = points.dropClose(threshold: pointsThreshold)
        let path = CGPath.between(points: filteredPoint)
        shapeLayer.set(value: path, for: .path, animated: animated)
    }

    private func setup() {
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = column?.cgColor
        addSublayer(shapeLayer)
    }

    private var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: lineWidth * 2, bottom: lineWidth * 2)
    }

    private var pointsThreshold: CGFloat = .pointsEpsilon
    private var range: Range<Int> = .zero
    private let shapeLayer = CAShapeLayer()
}
