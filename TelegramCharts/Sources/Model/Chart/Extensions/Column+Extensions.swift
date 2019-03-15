//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension ColumnType {
    var isDrawable: Bool {
        switch self {
        case .line: return true
        case .timestamps: return false
        }
    }

    var isTimestamps: Bool {
        switch self {
        case .line: return false
        case .timestamps: return true
        }
    }
}

extension Column {
    var range: Range<Int> {
        return values.range
    }

    var isEmpty: Bool {
        return values.isEmpty
    }

    var uiColor: UIColor? {
        return color.flatMap { UIColor(hex: $0) }
    }

    var cgColor: CGColor? {
        return uiColor?.cgColor
    }
}

extension Array where Element == Column {
    var range: Range<Int> {
        guard let first = first else {
            return .zero
        }

        return dropFirst().reduce(first.range) { range, column in
            range.union(with: column.range)
        }
    }
}
