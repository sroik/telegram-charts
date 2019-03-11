//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol ChartsService {
    typealias Completion = ([Chart]) -> Void
    func load(then completion: @escaping Completion)
}
