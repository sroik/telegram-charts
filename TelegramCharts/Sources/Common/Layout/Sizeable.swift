//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Sizeable {
    var size: CGSize { get }
}

extension UIView: Sizeable {
    var size: CGSize {
        return intrinsicContentSize
    }
}
