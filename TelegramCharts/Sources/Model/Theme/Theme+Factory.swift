//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension ThemeMode {
    var theme: Theme {
        switch self {
        case .day: return .day
        case .night: return .night
        }
    }

    var rotated: Theme {
        switch self {
        case .day: return .night
        case .night: return .day
        }
    }

    var title: String {
        switch self {
        case .day: return "Day"
        case .night: return "Night"
        }
    }
}

extension Theme {
    static let day = Theme(color: .day)
    static let night = Theme(color: .night)
}

extension ThemeColor {
    static let day = ThemeColor(
        background: .lightGray,
        placeholder: .white,
        navigation: .lightGray,
        tint: .blue,
        text: .black,
        details: .darkGray
    )

    static let night = ThemeColor(
        background: .darkGray,
        placeholder: .darkGray,
        navigation: .darkGray,
        tint: .blue,
        text: .white,
        details: .lightGray
    )
}
