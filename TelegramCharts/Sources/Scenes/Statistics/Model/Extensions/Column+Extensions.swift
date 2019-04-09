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

    func range(in viewport: Viewport) -> Range<Int> {
        return values.range(in: viewport)
    }
}

extension Array where Element == Column {
    var range: Range<Int> {
        return range(in: .zeroToOne)
    }

    func range(in viewport: Viewport) -> Range<Int> {
        guard let first = first else {
            return .zero
        }

        return dropFirst().reduce(first.values.range(in: viewport)) { r, c in
            r.union(with: c.range(in: viewport))
        }
    }
}
