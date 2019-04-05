//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CAAnimation {
    var endTime: CFTimeInterval {
        return beginTime + duration
    }

    var leftTime: CFTimeInterval {
        return endTime - CACurrentMediaTime()
    }
}
