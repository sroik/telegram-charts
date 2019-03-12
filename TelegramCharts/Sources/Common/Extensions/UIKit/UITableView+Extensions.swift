//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UITableView {
    typealias EnumerationBlock<C> = (C) -> Void

    func forEachVisibleCell<C: UITableViewCell>(do block: EnumerationBlock<C>) {
        visibleCells
            .compactMap { $0 as? C }
            .forEach { block($0) }
    }
}
