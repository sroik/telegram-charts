//
//  Copyright © 2019 Sroik. All rights reserved.
//

import UIKit

struct Device {
    static let scale = UIScreen.main.scale
    static let isFast = Device.isNotched
    static let isNotched = Device.safeAreaInsets.top > 1.0
    static let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
}
