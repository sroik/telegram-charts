//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct StackedColumnValue: Hashable {
    var id: String
    var value: Int
    var color: CGColor?
    var isEnabled: Bool

    init(
        id: String,
        value: Int,
        color: CGColor? = nil,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.value = value
        self.color = color
        self.isEnabled = isEnabled
    }
}

struct StackedColumn: Hashable {
    var index: Int
    var values: [StackedColumnValue]
}
