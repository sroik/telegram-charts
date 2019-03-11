//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
