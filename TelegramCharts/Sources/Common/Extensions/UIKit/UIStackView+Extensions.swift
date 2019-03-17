//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UIStackView {
    var intrinsicWidth: CGFloat {
        return arrangedSubviews
            .map { $0.intrinsicContentSize.width }
            .max() ?? 0
    }
}
