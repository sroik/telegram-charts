//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

/*
 I'm using separate data-structure because
 it's easy-storable in some settings and its way
 better than to store some pack of ui-colors
 */
enum ThemeMode: String, Codable {
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
}

struct Theme {
    let color: ThemeColor
}
