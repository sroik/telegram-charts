//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

enum Theme: String, Codable {
    case day
    case night
}

struct ThemeColor {
    let background: UIColor
    let placeholder: UIColor
    let navigation: UIColor
    let tint: UIColor
    let text: UIColor
    let details: UIColor
    let line: UIColor
    let gridLine: UIColor
    let card: UIColor
    let cardText: UIColor
    let cardIcon: UIColor
    let mapKnob: UIColor
    let mapDim: UIColor
}
