//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Bundle {
    static var test: Bundle {
        return Bundle(for: BundleStub.self)
    }
}

private class BundleStub {}
