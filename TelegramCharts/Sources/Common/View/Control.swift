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

    func themeUp() {
        subviews.theme(with: theme)
    }
}
