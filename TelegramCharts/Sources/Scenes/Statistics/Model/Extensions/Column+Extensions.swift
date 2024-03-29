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
        switch type {
        case .area, .bar:
            return Range(
                min: 0,
                max: values.elements(in: viewport).max() ?? 0
            )
        case .line:
            return values.range(in: viewport)
        case .timestamps:
            return .zero
        }
    }

    func values(in viewport: Viewport) -> [Int] {
        return Array(values.elements(in: viewport))
    }

    func with(valuesRange: Range<Int>) -> Column {
        let slice = values.elements(from: valuesRange.min, to: valuesRange.max)
        return Column(id: id, type: type, name: name, color: color, values: Array(slice))
    }
}

extension Array where Element == Column {
    var ids: [String] {
        return map { $0.id }
    }
}
