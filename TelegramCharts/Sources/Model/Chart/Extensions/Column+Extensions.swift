//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension ColumnType {
    var isDrawable: Bool {
        switch self {
        case .line, .area, .bar: return true
        case .timestamps: return false
        }
    }

    var isTimestamps: Bool {
        switch self {
        case .line, .area, .bar: return false
        case .timestamps: return true
        }
    }
}

extension Column {
    static var empty = Column(
        id: "",
        type: .line,
        name: nil,
        color: nil,
        values: []
    )

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
        return range(in: Range(min: 0, max: 1))
    }

    func range(in viewport: Range<CGFloat>) -> Range<Int> {
        guard let first = first else {
            return .zero
        }

        return dropFirst().reduce(first.values.range(in: viewport)) { r, c in
            r.union(with: c.values.range(in: viewport))
        }
    }
}
