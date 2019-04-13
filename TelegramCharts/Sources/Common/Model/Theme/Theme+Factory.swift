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

    var state: ThemeState {
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

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .day: return .default
        case .night: return .lightContent
        }
    }

    var title: String {
        switch self {
        case .day: return "Day"
        case .night: return "Night"
        }
    }
}

extension ThemeState {
    static let day = ThemeState(cornerRadius: 6)
    static let night = ThemeState(cornerRadius: 6)
}

extension ThemeColor {
    static let day = ThemeColor(
        background: UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1),
        placeholder: UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1),
        navigation: UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1),
        tint: UIColor(red: 16 / 255, green: 139 / 255, blue: 227 / 255, alpha: 1),
        text: .black,
        header: UIColor(red: 109 / 255, green: 109 / 255, blue: 114 / 255, alpha: 1),
        details: UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 0.5),
        line: UIColor(red: 207 / 255, green: 209 / 255, blue: 210 / 255, alpha: 1),
        gridLine: UIColor(red: 24 / 255, green: 45 / 255, blue: 59 / 255, alpha: 0.2),
        card: UIColor(red: 244 / 255, green: 244 / 255, blue: 247 / 255, alpha: 1),
        cardText: UIColor(red: 109 / 255, green: 109 / 255, blue: 114 / 255, alpha: 1),
        cardIcon: UIColor(red: 89 / 255, green: 96 / 255, blue: 109 / 255, alpha: 0.3),
        mapKnob: UIColor(red: 192 / 255, green: 209 / 255, blue: 225 / 255, alpha: 1),
        mapDim: UIColor(red: 226 / 255, green: 238 / 255, blue: 249 / 255, alpha: 0.6)
    )

    static let night = ThemeColor(
        background: UIColor(red: 23 / 255, green: 34 / 255, blue: 45 / 255, alpha: 1),
        placeholder: UIColor(red: 33 / 255, green: 48 / 255, blue: 64 / 255, alpha: 1),
        navigation: UIColor(red: 33 / 255, green: 48 / 255, blue: 64 / 255, alpha: 1),
        tint: UIColor(red: 46 / 255, green: 166 / 255, blue: 254 / 255, alpha: 1),
        text: .white,
        header: UIColor(red: 141 / 255, green: 157 / 255, blue: 177 / 255, alpha: 1),
        details: UIColor(red: 200 / 255, green: 228 / 255, blue: 238 / 255, alpha: 0.55),
        line: UIColor(red: 18 / 255, green: 27 / 255, blue: 35 / 255, alpha: 1),
        gridLine: UIColor(red: 200 / 255, green: 228 / 255, blue: 238 / 255, alpha: 0.1),
        card: UIColor(red: 25 / 255, green: 35 / 255, blue: 47 / 255, alpha: 1),
        cardText: .white,
        cardIcon: UIColor(red: 210 / 255, green: 213 / 255, blue: 215 / 255, alpha: 0.3),
        mapKnob: UIColor(red: 86 / 255, green: 98 / 255, blue: 109 / 255, alpha: 1),
        mapDim: UIColor(red: 24 / 255, green: 34 / 255, blue: 45 / 255, alpha: 0.6)
    )

    var barOverlay: UIColor {
        return placeholder.withAlphaComponent(0.5)
    }
}
