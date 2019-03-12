//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Theme {
    var color: ThemeColor {
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

extension ThemeColor {
    static let day = ThemeColor(
        background: UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1),
        placeholder: UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1),
        navigation: UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1),
        tint: UIColor(red: 1 / 255, green: 126 / 255, blue: 229 / 255, alpha: 1),
        text: .black,
        header: UIColor(red: 109 / 255, green: 109 / 255, blue: 114 / 255, alpha: 1),
        details: UIColor(red: 152 / 255, green: 158 / 255, blue: 162 / 255, alpha: 1),
        line: UIColor(red: 207 / 255, green: 209 / 255, blue: 210 / 255, alpha: 1)
    )

    static let night = ThemeColor(
        background: UIColor(red: 24 / 255, green: 34 / 255, blue: 45 / 255, alpha: 1),
        placeholder: UIColor(red: 33 / 255, green: 48 / 255, blue: 64 / 255, alpha: 1),
        navigation: UIColor(red: 33 / 255, green: 48 / 255, blue: 64 / 255, alpha: 1),
        tint: UIColor(red: 1 / 255, green: 126 / 255, blue: 229 / 255, alpha: 1),
        text: .white,
        header: UIColor(red: 91 / 255, green: 107 / 255, blue: 127 / 255, alpha: 1),
        details: UIColor(red: 91 / 255, green: 107 / 255, blue: 127 / 255, alpha: 1),
        line: UIColor(red: 18 / 255, green: 27 / 255, blue: 35 / 255, alpha: 1)
    )
}
