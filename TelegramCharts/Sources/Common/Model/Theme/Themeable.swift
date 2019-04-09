//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Themeable: AnyObject {
    var theme: Theme { get set }
}

extension Array {
    func theme(with theme: Theme) {
        compactMap { $0 as? Themeable }.forEach { $0.theme = theme }
    }
}
