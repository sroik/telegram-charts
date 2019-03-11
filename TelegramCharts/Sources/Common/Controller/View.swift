//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

class View: UIView, Themeable {
    var theme: Theme = .day {
        didSet {
            themeUp()
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func themeUp() {
        subviews.theme(with: theme)
    }
}
