//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ColumnLayer: CALayer {
    var viewport: Range<Int> = .zero {
        didSet {
            draw(animated: true)
        }
    }

    var lineWidth: CGFloat = 1 {
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

    override func layoutSublayers() {
        super.layoutSublayers()
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
        let points = column.points(in: shapeLayer.bounds, viewport: viewport)
        let path = CGPath.between(points: points)
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
