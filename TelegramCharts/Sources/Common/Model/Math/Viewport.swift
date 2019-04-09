//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias Viewport = Range<CGFloat>

protocol Viewportable {
    var viewport: Viewport { get set }
}
