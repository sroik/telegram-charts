//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class Control: UIControl, Themeable {
    var theme: Theme = .day {
        didSet {
            themeUp()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        themeUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if laidoutBounds.distance(to: bounds) > .layoutEpsilon {
            laidoutBounds = bounds
            layoutSubviewsOnBoundsChange()
        }
    }

    func layoutSubviewsOnBoundsChange() {
        /* meant to be inherited */
    }

    func themeUp() {
        subviews.theme(with: theme)
    }

    private var laidoutBounds: CGRect = .zero
}
