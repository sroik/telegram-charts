//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension ThemeMode {
    var theme: Theme {
        switch self {
        case .day: return .day
        case .night: return .night
        }
    }

    var rotated: ThemeMode {
        switch self {
        case .day: return .night
        case .night: return .day
        }
    }

    var title: String {
        switch self {
        case .day: return "day"
        case .night: return "night"
        }
    }
}

extension Theme {
    static let day = Theme(color: .day)
    static let night = Theme(color: .night)
}

extension ThemeColor {
    static let day = ThemeColor(
        background: UIColor(white: 0.85, alpha: 1.0),
        placeholder: UIColor(white: 1.0, alpha: 1.0),
        navigation: UIColor(white: 0.9, alpha: 1.0),
        tint: .blue,
        text: UIColor(white: 0.1, alpha: 1.0),
        details: UIColor(white: 0.5, alpha: 1.0)
    )

    static let night = ThemeColor(
        background: UIColor(white: 0.35, alpha: 1.0),
        placeholder: UIColor(white: 0.2, alpha: 1.0),
        navigation: UIColor(white: 0.2, alpha: 1.0),
        tint: .blue,
        text: UIColor(white: 1.0, alpha: 1.0),
        details: UIColor(white: 0.6, alpha: 1.0)
    )
}
