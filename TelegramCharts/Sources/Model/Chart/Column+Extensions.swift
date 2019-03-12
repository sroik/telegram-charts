//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Column {
    var range: Range<Int> {
        return values.range
    }
}

extension ColumnType {
    var isDrawable: Bool {
        switch self {
        case .line: return true
        case .timestamps: return false
        }
    }
}
