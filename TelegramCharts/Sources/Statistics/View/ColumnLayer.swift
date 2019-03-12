//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class ColumnLayer: CALayer {
    var viewportRange: Range<Int> = .zero {
        didSet {
            draw()
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
        layer.frame = bounds
        draw()
    }

    private func setup() {
        addSublayer(layer)
    }

    private func draw() {
        #warning("fix")
        layer.backgroundColor = UIColor.yellow.cgColor
    }

    private let column: Column?
    private let layer = CAShapeLayer()
}
