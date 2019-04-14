//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Layer: CALayer, Themeable {
    var theme: Theme = .day {
        didSet {
            if oldValue != theme {
                themeUp()
            }
        }
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        if laidoutBounds.distance(to: bounds) > .layoutEpsilon {
            laidoutBounds = bounds
            layoutSublayersOnBoundsChange()
        }
    }

    func themeUp() {
        sublayers?.theme(with: theme)
    }

    func layoutSublayersOnBoundsChange() {
        /* meant to be inherited */
    }

    private var laidoutBounds: CGRect = .zero
}

class ActionlessTextLayer: CATextLayer {
    var actionsEnabled: Bool = false

    override func action(forKey event: String) -> CAAction? {
        return actionsEnabled ? super.action(forKey: event) : nil
    }
}
