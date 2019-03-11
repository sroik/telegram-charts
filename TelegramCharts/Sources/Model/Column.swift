//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

enum ColumnType: String {
    case timestamps = "x"
    case line
}

struct Column {
    let label: String
    let type: ColumnType
    let name: String
    let color: HexColor
    var values: [Int]
}
