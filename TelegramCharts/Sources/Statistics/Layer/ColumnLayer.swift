//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ColumnLayer: Layer {
    var range: Range<Int> = .zero {
        didSet {
            if oldValue != range {
                draw(animated: true)
            }
        }
    }

    var lineWidth: CGFloat = 2 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }

    var pointsThreshold: CGFloat = .pointsEpsilon {
        didSet {
            if oldValue != pointsThreshold {
                draw(animated: true)
            }
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
        draw()
    }

    func draw(animated: Bool = false) {
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

    private let shapeLayer = CAShapeLayer()
}
