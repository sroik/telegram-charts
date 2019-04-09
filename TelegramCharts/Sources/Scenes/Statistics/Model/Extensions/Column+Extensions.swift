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
