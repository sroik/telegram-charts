//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ColumnLayer: CALayer {
    var viewport: Range<Int> = .zero {
        didSet {
            draw()
        }
    }

    var lineWidth: CGFloat = 1 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }

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

    override func layoutSublayers() {
        super.layoutSublayers()
        shapeLayer.frame = bounds
        draw()
    }

    private func setup() {
        addSublayer(shapeLayer)
    }

    private func draw() {
        guard let column = column else {
            return
        }

        switch column.type {
        case .line:
            drawLineColumn(column)
        default:
            assertionFailureWrapper("column type is not supported yet")
        }
    }

    private func drawLineColumn(_ column: Column) {
        let points = column.points(in: bounds, viewport: viewport)
        let path = CGPath.between(points: points)

        shapeLayer.path = path
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = column.cgColor
    }

    private let column: Column?
    private let shapeLayer = CAShapeLayer()
}
